// scripts/publish_release.kts
// Gradle Kotlin Script for Automated Version Bumping & GitHub Tag Creation
//
// Can be executed via Gradle:
//   ./gradlew publishRelease
//   ./gradlew publishRelease -Pbump=minor
//   ./gradlew publishRelease -Pbump=major
//   ./gradlew publishRelease -Pver=1.2.0
//   ./gradlew publishRelease -Ppush=true
//   ./gradlew publishRelease -PdryRun=true

tasks.register("publishRelease") {
  group = "publishing"
  description = "Automates version bumping in gradle.properties and Git tag creation for GitHub Releases."
  notCompatibleWithConfigurationCache("Interactive publishing task performing Git commits and dynamic property updates")

  val propFile = layout.projectDirectory.file("gradle.properties").asFile
  val rootDirFile = layout.projectDirectory.asFile
  val bumpTypeProp = providers.gradleProperty("bump").getOrElse("patch").lowercase()
  val explicitVerProp = providers.gradleProperty("ver").orNull
  val shouldPushProp = providers.gradleProperty("push").map { it.toBoolean() }.getOrElse(false)
  val dryRunProp = providers.gradleProperty("dryRun").map { it.toBoolean() }.getOrElse(false)
  val customMsgProp = providers.gradleProperty("message").orNull

  doLast {
    val bumpType = bumpTypeProp
    val explicitVer = explicitVerProp
    val shouldPush = shouldPushProp
    val dryRun = dryRunProp
    val customMsg = customMsgProp

    if (!propFile.exists()) {
      throw GradleException("gradle.properties not found in root directory: ${propFile.absolutePath}")
    }

    val content = propFile.readText()
    val codeRegex = Regex("""^app\.version\.code=(\d+)""", RegexOption.MULTILINE)
    val nameRegex = Regex("""^app\.version\.name=([^\r\n]+)""", RegexOption.MULTILINE)

    val currentCode = codeRegex.find(content)?.groupValues?.get(1)?.toInt()
      ?: throw GradleException("Could not find app.version.code in gradle.properties")
    val currentName = nameRegex.find(content)?.groupValues?.get(1)?.trim()
      ?: throw GradleException("Could not find app.version.name in gradle.properties")

    val semverRegex = Regex("""^(\d+)\.(\d+)\.(\d+)(.*)$""")
    val semverMatch = semverRegex.find(currentName)
    val major = semverMatch?.groupValues?.get(1)?.toInt() ?: 1
    val minor = semverMatch?.groupValues?.get(2)?.toInt() ?: 0
    val patch = semverMatch?.groupValues?.get(3)?.toInt() ?: 0
    val suffix = semverMatch?.groupValues?.get(4) ?: ""

    val nextVersionName = when {
      explicitVer != null -> explicitVer.removePrefix("v")
      bumpType == "minor" -> "$major.${minor + 1}.0$suffix"
      bumpType == "major" -> "${major + 1}.0.0$suffix"
      else -> "$major.$minor.${patch + 1}$suffix"
    }
    val nextVersionCode = currentCode + 1
    val nextTag = "v$nextVersionName"

    println("==================================================================")
    println("🚀 AetherStudio Elite - Version Bump & Tag Publisher")
    println("==================================================================")
    println("📌 Current Version: v$currentName (versionCode: $currentCode)")
    println("✨ Target Version:  $nextTag (versionCode: $nextVersionCode) [bump: $bumpType]")
    println("==================================================================")

    if (dryRun) {
      println("🔍 [DRY-RUN] Would update gradle.properties to:")
      println("   app.version.code=$nextVersionCode")
      println("   app.version.name=$nextVersionName")
      println("🔍 [DRY-RUN] Would create Git tag: $nextTag")
      if (shouldPush) {
        println("🔍 [DRY-RUN] Would push: git push origin HEAD && git push origin $nextTag")
      }
      return@doLast
    }

    var updatedProps = content
    updatedProps = codeRegex.replace(updatedProps, "app.version.code=$nextVersionCode")
    updatedProps = nameRegex.replace(updatedProps, "app.version.name=$nextVersionName")
    propFile.writeText(updatedProps)
    println("✅ Updated gradle.properties successfully.")

    fun runGit(vararg cmd: String): Pair<Int, String> {
      val proc = ProcessBuilder("git", *cmd)
        .directory(rootDirFile)
        .redirectOutput(ProcessBuilder.Redirect.PIPE)
        .redirectError(ProcessBuilder.Redirect.PIPE)
        .start()
      val stdout = proc.inputStream.bufferedReader().readText().trim()
      val stderr = proc.errorStream.bufferedReader().readText().trim()
      val code = proc.waitFor()
      return Pair(code, if (stdout.isNotBlank()) stdout else stderr)
    }

    val isGit = runGit("rev-parse", "--is-inside-work-tree").first == 0
    if (isGit) {
      val commitMsg = "chore(release): bump version to $nextTag (code: $nextVersionCode)"
      val tagMsg = customMsg ?: "Release $nextTag: Production build with multi-format publishing & levitating studio pod"

      runGit("add", "gradle.properties")
      runGit("commit", "-m", commitMsg)
      println("✅ Created Git commit: \"$commitMsg\"")

      runGit("tag", "-a", nextTag, "-m", tagMsg)
      println("🏷️  Created Git Tag: $nextTag")

      if (shouldPush) {
        println("📤 Pushing commit and tag to origin...")
        runGit("push", "origin", "HEAD")
        runGit("push", "origin", nextTag)
        println("🎉 Tag pushed! GitHub Actions release workflow triggered.")
      } else {
        println("\n👉 Run this command to publish and trigger GitHub Actions build:")
        println("   git push origin HEAD && git push origin $nextTag\n")
      }
    } else {
      println("⚠️ Not inside Git repository. gradle.properties updated, git tag skipped.")
    }
  }
}
