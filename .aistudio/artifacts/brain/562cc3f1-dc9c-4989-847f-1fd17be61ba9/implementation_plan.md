# Comprehensive Studio Upgrade: Auth, Collaboration, Studio Sidebar & Smart Templates

This plan outlines the architecture and execution steps for integrating Google & Email authentication, profile editing with device photo library upload, Figma-style collaborative group projects, hiding animation UI on static canvases, removing top bar color clutter, adding a CapCut/Canva collapsible tool sidebar, and providing interactive smart editable templates.

---

## User Review & Critical Decisions

> [!IMPORTANT]
> The following decisions were confirmed during the Phase 1 questionnaire and will guide the implementation:

- **Confirmed Decision 1 (Authentication Flow)**: Provide a frictionless authentication experience where users start in a clean profile view with 1-tap options for "Sign in with Google" or "Sign in with Email & Password". Signed-in profiles persist locally in device storage with custom avatars imported from the device photo library.
- **Confirmed Decision 2 (Studio Sidebar)**: Implement a sleek collapsible left drawer styled after CapCut and Canva, housing Elements, Text, Layers, Filters, AI Studio, and Adjustments, keeping the canvas spacious on phones while expanding smoothly on larger displays.
- **Confirmed Decision 3 (Group Projects)**: Projects tab will feature a dedicated "+ Group Project" action generating instant room codes with multi-user presence avatars and simulated peer live cursors (Figma-style).
- **Confirmed Decision 4 (Canvas Decluttering)**: The animation filmstrip and timeline will be hidden on all standard static canvases, appearing strictly when an Animation project is active. The color palette bar on the top header will be streamlined into the tool drawer to avoid top-edge clutter.

---

## 1. Overview & Core Concept

- **What It Does**:
  1. **Authentication & Profile Hub**: Complete login modal with Google OAuth simulation and Email/Password fields. Displays profile card with custom avatar (from device library), full name, and @username handle. Includes an "Edit Profile" modal to customize profile details anytime.
  2. **Figma Group Projects**: Group project creator in the Projects tab allowing users to generate shareable room codes, see connected collaborator avatars, and experience real-time cursor indicators.
  3. **Contextual Canvas UI**: Hides animation controls when editing standard illustrations and removes top bar color clutter, placing color selection in the primary tool palette.
  4. **CapCut / Canva Studio Sidebar**: Expandable left navigation rail featuring Elements, Text, Filters, Layers, and AI Tools tailored for mobile and tablet touch ergonomics.
  5. **Smart Canva-Style Templates**: Curated royalty-free templates with editable text, background, and graphic layers that can be selected and manipulated directly on the canvas.

---

## 2. User Experience & Visual Design

### Key User Flows

1. **Profile Authentication & Avatar Customization**:
   - User navigates to the **Profile** tab in the bottom dock.
   - If not logged in, user sees a sleek login card with:
     - `Continue with Google` (One-tap sign in)
     - `Sign in with Email & Password` (Form fields with toggle)
   - Once signed in, user sees a prominent Profile Card showing their avatar image, Name, and `@username`.
   - User taps **Edit Profile**: a drawer opens allowing them to pick an image from their phone photo library, update their Name and Username, and save immediately to device storage.
2. **Starting a Group Project (Figma Style)**:
   - User navigates to the **Projects** tab and taps **+ Group Project**.
   - A modal prompts for project title and generates a 6-digit room code (e.g. `AETH-7429`) with a "Copy Invite Link" action.
   - Upon launching the project, the studio shows collaborator avatars in the header and peer presence cursors on canvas.
3. **Clean Canvas Studio & Sidebar**:
   - When opening a standard canvas, the bottom animation filmstrip is automatically hidden.
   - The top header remains ultra-clean (Undo/Redo, Zoom, Symmetry, Analyze, Publish).
   - Tapping the left sidebar toggle reveals the Canva/CapCut tool flyout:
     - **Elements**: Geometric badges, ribbons, arrows, stars.
     - **Text**: Heading, Subtitle, Body text presets.
     - **Filters**: Brightness, Contrast, Saturation, Vignette.
     - **Layers**: Reorder, opacity, blend mode.

### Visual Identity & Theme Tokens

```css
:root {
  --sidebar-bg: rgba(14, 16, 26, 0.95);
  --sidebar-width: 64px;
  --sidebar-expanded: 260px;
  --presence-user-1: #06b6d4;
  --presence-user-2: #ec4899;
  --presence-user-3: #10b981;
}
```

---

## 3. Key Product Decisions & Trade-Offs

### Decision 1: Collapsible Sidebar vs Fixed Dock
- **Chosen Approach**: A compact 56px left vertical rail with collapsible slide-out drawer on phones, which expands to a full side panel on wider viewports.
- **Why**: Protects valuable canvas real-estate on mobile phones while providing instant access to Canva/CapCut-level tools.

### Decision 2: Local & Simulated Multi-User Presence
- **Chosen Approach**: Peer presence simulation with real room-code persistence, collaborator avatars in header, and active peer cursor position tracking.
- **Why**: Works 100% offline and in emulator environments without requiring paid Firebase authentication credentials, fulfilling the user's explicit request.

---

## 4. Technical Architecture & Component Structure

```
┌────────────────────────────────────────────────────────────────────────┐
│                        AetherStudio Architecture                       │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Navigation Dock: Home | Templates | Projects | Profile           │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│  ┌─────────────────────────┐  ┌──────────────────────────────────────┐  │
│  │ CapCut / Canva Sidebar  │  │ Canvas Workspace                     │  │
│  │  - Elements & Shapes    │  │  - Clean Header (No palette clutter) │  │
│  │  - Typography & Text    │  │  - Pure Drawing Stage                │  │
│  │  - Filters & Inpainting │  │  - Animation Timeline (Anim ONLY)    │  │
│  │  - Layers & Blends      │  │  - Peer Collaborative Cursors (Live) │  │
│  └─────────────────────────┘  └──────────────────────────────────────┘  │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Profile Engine                                                   │  │
│  │  - Google & Email Auth State Machine                             │  │
│  │  - Device Photo Library Avatar Upload (FileReader -> localStorage)│  │
│  │  - Username & Name Editor Modal                                  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Verification Plan

1. Verify profile login flow (Google 1-tap and Email/Password).
2. Verify photo library picker updates profile avatar and persists across app restarts.
3. Verify "+ Group Project" creates a collaborative room with collaborator avatars and peer cursor motion.
4. Verify standard canvas projects do not display the animation timeline panel.
5. Verify canvas top bar is clean with no redundant color palette.
6. Verify CapCut/Canva sidebar toggles and adds text/elements to canvas.
7. Run `compile_applet` and verify zero build errors.
