# GraphenX: Professional Authentication, User Onboarding, and High-Performance Studio Engine

## User Review & Critical Decisions

> [!IMPORTANT]
> The following architectural and user experience decisions have been synthesized from your feedback:

- **Confirmed Decision (Authentication)**: Initial app launch presents a professional dark glass login screen with real Google Sign-In and email options. Users start in an unauthenticated state (`isLoggedIn: false`) by default.
- **Confirmed Decision (Onboarding Flow)**: Immediately upon first sign-in, users transition to a dedicated onboarding page to set their Full Name, claim a unique `@username` (with real-time format and availability check), and select or upload an avatar before entering the studio.
- **Confirmed Decision (Performance & Project Launch)**: Instant canvas mount, elimination of duplicate function handlers, and hardware-accelerated rendering to completely remove lag and make project opening, templates, and AI tools immediately responsive.
- **Confirmed Decision (Button UI & Branding)**: Clean "+project" and "+ Canvas" labels into sleek "New Project" / "Create Project" action buttons without unnecessary `+` prefixes, and rebrand the application name strictly to **GraphenX** across Android metadata, strings, Gradle, and all UI views.

---

## 1. Overview & Core Concept

**GraphenX** is a high-performance creative design and animation studio. This release elevates the application from a guest-first prototype into a polished, professional multi-engine studio with:
1. **Unauthenticated First Launch**: A luxury glassmorphic login screen featuring authentic Google Sign-In and email authentication.
2. **Post-Sign-In Onboarding Page**: A focused setup flow allowing each creator to personalize their display identity, select an avatar, and secure a unique `@username`.
3. **Zero-Lag Studio Engine**: Instant project launching, rapid template application (Canva, PhotoRoom, Pinterest, Google), and high-framerate AI tool execution without UI freeze or click-blocker overlays.
4. **Clean Action Labels**: Removal of awkward `+` prefixes in favor of standard studio actions like "New Project" and "Create Artwork".
5. **Universal Rebranding to GraphenX**: Consistent identity across the system manifest, Gradle build, Android strings, splash screen, and top navigation bar.

---

## 2. User Experience & Visual Design

### Key User Flows

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           1. FIRST LAUNCH (AUTH)                            │
│  Luxury Dark Glass Authentication Screen (isLoggedIn: false)               │
│  • Google Sign-In (Real Google OAuth / GIS button with official logo)       │
│  • Email / Password Tab with sleek input fields & validation                │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      2. ONBOARDING & USERNAME SETUP                         │
│  Personalization Screen (appears on first sign-in):                         │
│  • Full Name input field                                                    │
│  • Unique @username selector with live availability check                   │
│  • Avatar selection carousel & photo upload picker                          │
│  • "Complete Setup & Enter GraphenX" Primary Action                         │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         3. GRAPHENX HOME DASHBOARD                          │
│  • Clean "New Project" hero button (removed awkward '+' prefix)             │
│  • Instant-opening Projects Grid (Figma, Photoshop, Procreate cards)        │
│  • 1-Click Editable Templates (Canva, PhotoRoom, Pinterest, Google)         │
│  • Engine Mode Switcher (Graphic Design vs. Drawing & Animation)            │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          4. LAG-FREE STUDIO CANVAS                          │
│  • Instant canvas mount with GPU hardware acceleration                      │
│  • Unfrozen AI Tools (Background removal, artistic vision, blend modes)     │
│  • Keyframe timeline with linear opacity fade transitions                   │
│  • Universal Save button with tactile flash feedback                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Visual Identity & Theme
- **Aesthetic Direction**: Luxury Cyber-Minimal Dark Glass (`#07080E` base with `#12141F` card surfaces, subtle 1px border glows `rgba(255,255,255,0.12)`, and electric cyan `#06B6D4` / royal purple `#8B5CF6` accents).
- **Typography & Hierarchy**: Inter / Outfit modern sans-serif typography with high-contrast numerical tracking for dimensions and frame rates.
- **Feedback & Motion**: Micro-spring animations for button clicks, smooth opacity cross-fades during screen transitions, and tactile toast notifications.

---

## 3. Key Product Decisions & Trade-Offs

### Decision 1: Authentication Architecture & Initial State
- **Chosen Approach**: Users start signed out (`isLoggedIn: false`). The app displays an unauthenticated luxury login screen. Signing in with Google captures authentic account identity (`ma0780542@gmail.com`), initializes user credentials, and forwards new users to the Onboarding Page.
- **Why**: The user explicitly requested: *"And the login page must not signed in and make real professional sign in or login why its looks so stupid and make real google sign in"*.
- **Alternatives Considered**: Auto-logging in as a mock guest user was rejected because it bypassed authentication and confused the login flow.

### Decision 2: Dedicated Post-Sign-In Onboarding Page
- **Chosen Approach**: A separate dedicated onboarding screen that automatically opens after sign-in if the user has not configured their unique username. The form validates the `@username` against regex rules (`^[a-zA-Z0-9_]{3,20}$`) and existing local/cloud records, ensures uniqueness, provides avatar selection, and saves the verified profile to GraphenX Vault.
- **Why**: Directly addresses *"make another page after sign in or login page that allows users to set up their name and a uniqe username for each person"*.

### Decision 3: Resolving Project Launching, Template, and AI Responsiveness (Eliminating Lag)
- **Chosen Approach**:
  1. Deduplicate and fix `launchStudioWithProject` and `launchStudioWithProjectById`: ensure switching screens properly hides `#home-screen` and displays `#app-container` without hanging.
  2. Optimize canvas stage initialization: avoid re-creating offscreen buffer canvases on every click; use single-instance pooled canvases.
  3. Ensure modal z-indexes and touch pointer events do not leave transparent blocking overlays over project cards.
  4. Enable GPU hardware acceleration layers (`will-change: transform`, `transform: translateZ(0)`) across active canvas tools.
- **Why**: Resolves *"Nothing is working not opening the projects... And everything is laggy and projects and templates and ai tools are not responding"*.

### Decision 4: Button Labeling & App Naming
- **Chosen Approach**: Replace all `+ Canvas`, `+ Group`, and `+ Project` labels with clean modern labels like `New Project`, `Create Canvas`, and `Group Space`. Update app name everywhere to **GraphenX** (matching the capitalized `X`).
- **Why**: Fulfills *"Remove that + from "+project""* and *"change name to GraphenX also the app name on everything"*.

---

## 4. Technical Architecture & Component Mapping

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          GRAPHENX SYSTEM ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  Android Layer:                                                             │
│  MainActivity.kt ──► StudioWebView (Hardware Accelerated, JS Interface)     │
│  PublishingBridge.kt ──► Android MediaStore & Share Intent Engine           │
├─────────────────────────────────────────────────────────────────────────────┤
│  Web / Presentation Layer (index.html):                                     │
│                                                                             │
│  ┌───────────────────────┐   ┌───────────────────────┐   ┌──────────────┐  │
│  │ #auth-screen          │──►│ #onboarding-screen    │──►│ #home-screen │  │
│  │ (Google Sign-In,      │   │ (Unique @username,    │   │ (Projects,   │  │
│  │  Email Auth, Pass)    │   │  Full Name, Avatars)  │   │  Templates)  │  │
│  └───────────────────────┘   └───────────────────────┘   └──────┬───────┘  │
│                                                                 │           │
│                                      launchStudioWithProject()  ▼           │
│                              ┌──────────────────────────────────────────┐   │
│                              │ #app-container (GraphenX Multi-Engine)   │   │
│                              │ • Graphic Design (Photoshop, Figma)      │   │
│                              │ • Drawing & Anim (Procreate, FlipaClip)  │   │
│                              │ • Timeline & Linear Opacity Fade         │   │
│                              │ • Universal Save & Vault Persistence     │   │
│                              └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Component & State Mapping

| View / Component | State Variable | User Interaction & Handlers |
| :--- | :--- | :--- |
| **Auth Screen** (`#auth-screen`) | `userProfile.isLoggedIn = false` | • `handleGoogleSignIn()`: Authenticates with Google account.<br>• `handleEmailSignIn()`: Authenticates via email/password.<br>• Shows error toast on invalid inputs. |
| **Onboarding Screen** (`#onboarding-screen`) | `userProfile.username`, `userProfile.name`, `userProfile.avatar` | • `validateUniqueUsername(val)`: Real-time checks for uniqueness and format.<br>• `selectOnboardingAvatar(url)`: Picks avatar style.<br>• `completeUserOnboarding()`: Persists profile and opens dashboard. |
| **Home Dashboard** (`#home-screen`) | `appState.activeHomeTab`, `appState.projects` | • "New Project" button (`openNewProjectModal`): Cleaned label without `+`.<br>• Project cards (`launchStudioWithProject`): Fast, unblocked transition to studio.<br>• Templates tab & Quick Modal (`applyTemplateToCanvas`): Loads templates immediately. |
| **Studio Workspace** (`#app-container`) | `appState.activeEngine`, `appState.layers`, `appState.frames` | • Engine switcher: Adapts UI without affecting canvas.<br>• Timeline: Opacity Fade transition badges and linear cross-dissolve.<br>• AI Tools: BG Remove & Artistic Vision with instant feedback.<br>• Universal Save (`executeUniversalSave`): Vault snapshot with visual flash. |
