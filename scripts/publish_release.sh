#!/usr/bin/env bash
# ==============================================================================
# AetherStudio Elite - Automated Release & GitHub Tag Publishing Script
# ==============================================================================
# Usage:
#   ./scripts/publish_release.sh [patch|minor|major|<version>] [options]
#
# Options:
#   -p, --push       Push commit and release tag to origin remote immediately
#   -d, --dry-run    Preview version bump without modifying files or git tags
#   -m, --message    Custom annotation message for the release tag
#   -h, --help       Show this help message
# ==============================================================================

set -e

BUMP_TYPE="patch"
EXPLICIT_VERSION=""
PUSH_TO_REMOTE=false
DRY_RUN=false
CUSTOM_MESSAGE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    patch|minor|major)
      BUMP_TYPE="$1"
      shift
      ;;
    v[0-9]*|[0-9]*)
      EXPLICIT_VERSION="${1#v}"
      BUMP_TYPE="explicit"
      shift
      ;;
    -p|--push)
      PUSH_TO_REMOTE=true
      shift
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -m|--message)
      CUSTOM_MESSAGE="$2"
      shift 2
      ;;
    -h|--help)
      echo "AetherStudio Elite - Release Publisher"
      echo ""
      echo "Usage:"
      echo "  ./scripts/publish_release.sh [patch|minor|major|<version>] [options]"
      echo ""
      echo "Bump Types:"
      echo "  patch (default)   Increment patch version (e.g., 1.0.0 -> 1.0.1)"
      echo "  minor             Increment minor version (e.g., 1.0.0 -> 1.1.0)"
      echo "  major             Increment major version (e.g., 1.0.0 -> 2.0.0)"
      echo "  1.2.3             Set an explicit version"
      echo ""
      echo "Options:"
      echo "  -p, --push        Push commit & tag to GitHub to trigger Actions CI/CD"
      echo "  -d, --dry-run     Show what would happen without altering files"
      echo "  -m, --message     Custom annotation message for git tag"
      echo "  -h, --help        Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run './scripts/publish_release.sh --help' for usage."
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROPS_FILE="$ROOT_DIR/gradle.properties"

if [[ ! -f "$PROPS_FILE" ]]; then
  echo "❌ Error: gradle.properties not found at $PROPS_FILE"
  exit 1
fi

CURRENT_CODE=$(grep -E '^app\.version\.code=' "$PROPS_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
CURRENT_NAME=$(grep -E '^app\.version\.name=' "$PROPS_FILE" | cut -d'=' -f2 | tr -d '[:space:]')

if [[ -z "$CURRENT_CODE" || -z "$CURRENT_NAME" ]]; then
  echo "❌ Error: Could not parse app.version.code or app.version.name from gradle.properties"
  exit 1
fi

echo "=================================================================="
echo "🚀 AetherStudio Elite - Version Bump & Tag Publisher"
echo "=================================================================="
echo "📌 Current Version: v$CURRENT_NAME (versionCode: $CURRENT_CODE)"

# Split semver
IFS='.' read -r MAJOR MINOR PATCH_EXTRA <<< "$CURRENT_NAME"
PATCH="${PATCH_EXTRA%%-*}"
EXTRA="${PATCH_EXTRA#"$PATCH"}"

if [[ -z "$MAJOR" ]]; then MAJOR=1; fi
if [[ -z "$MINOR" ]]; then MINOR=0; fi
if [[ -z "$PATCH" ]]; then PATCH=0; fi

if [[ "$BUMP_TYPE" == "explicit" ]]; then
  NEXT_NAME="$EXPLICIT_VERSION"
elif [[ "$BUMP_TYPE" == "major" ]]; then
  NEXT_NAME="$((MAJOR + 1)).0.0$EXTRA"
elif [[ "$BUMP_TYPE" == "minor" ]]; then
  NEXT_NAME="$MAJOR.$((MINOR + 1)).0$EXTRA"
else
  NEXT_NAME="$MAJOR.$MINOR.$((PATCH + 1))$EXTRA"
fi

NEXT_CODE=$((CURRENT_CODE + 1))
NEXT_TAG="v$NEXT_NAME"

echo "✨ Next Version:    $NEXT_TAG (versionCode: $NEXT_CODE) [bump: $BUMP_TYPE]"
echo "=================================================================="

if [[ "$DRY_RUN" == true ]]; then
  echo "🔍 [DRY-RUN] Would update $PROPS_FILE to:"
  echo "   app.version.code=$NEXT_CODE"
  echo "   app.version.name=$NEXT_NAME"
  echo "🔍 [DRY-RUN] Would commit and create tag: $NEXT_TAG"
  if [[ "$PUSH_TO_REMOTE" == true ]]; then
    echo "🔍 [DRY-RUN] Would push to origin: git push origin HEAD && git push origin $NEXT_TAG"
  fi
  exit 0
fi

# Update gradle.properties using portable sed / awk
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -E "s/^app\.version\.code=[0-9]+/app.version.code=$NEXT_CODE/" "$PROPS_FILE"
  sed -i '' -E "s/^app\.version\.name=.*/app.version.name=$NEXT_NAME/" "$PROPS_FILE"
else
  sed -i -E "s/^app\.version\.code=[0-9]+/app.version.code=$NEXT_CODE/" "$PROPS_FILE"
  sed -i -E "s/^app\.version\.name=.*/app.version.name=$NEXT_NAME/" "$PROPS_FILE"
fi

echo "✅ Updated gradle.properties successfully."

# Check if inside git repo
if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Check if tag exists
  if git -C "$ROOT_DIR" rev-parse "$NEXT_TAG" >/dev/null 2>&1; then
    echo "❌ Error: Tag $NEXT_TAG already exists in git repository!"
    exit 1
  fi

  COMMIT_MSG="chore(release): bump version to $NEXT_TAG (code: $NEXT_CODE)"
  TAG_MSG="${CUSTOM_MESSAGE:-Release $NEXT_TAG: Production build with multi-format publishing & levitating studio pod}"

  git -C "$ROOT_DIR" add gradle.properties
  git -C "$ROOT_DIR" commit -m "$COMMIT_MSG"
  echo "✅ Created Git commit: \"$COMMIT_MSG\""

  git -C "$ROOT_DIR" tag -a "$NEXT_TAG" -m "$TAG_MSG"
  echo "🏷️  Created Git Tag: $NEXT_TAG"

  if [[ "$PUSH_TO_REMOTE" == true ]]; then
    echo "📤 Pushing to remote..."
    git -C "$ROOT_DIR" push origin HEAD
    git -C "$ROOT_DIR" push origin "$NEXT_TAG"
    echo "🎉 Successfully pushed tag $NEXT_TAG to origin!"
    echo "🚀 GitHub Actions release pipeline has started! Check your repo's Actions tab."
  else
    echo ""
    echo "🎉 Release prepared locally!"
    echo "👉 Run this command to publish and trigger GitHub Actions build:"
    echo "   git push origin HEAD && git push origin $NEXT_TAG"
    echo ""
  fi
else
  echo "⚠️ Not inside a Git repository. gradle.properties was updated, but git tagging was skipped."
fi
