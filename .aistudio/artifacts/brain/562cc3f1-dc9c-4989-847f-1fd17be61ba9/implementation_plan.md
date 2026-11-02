# Graphenx - Multi-Engine Creative Studio & Opacity Fade Timeline

Deliver a studio-grade multi-engine creative workspace under the official name **Graphenx** with a top-right engine switcher (Graphic Design: Photoshop & Figma; Drawing & Animation: Procreate, Ibis Paint, Krita & FlipaClip), full canvas data preservation, linear Opacity Fade keyframe transitions in the animation timeline, complete removal of unnecessary emojis in favor of precision SVG icons, a universal save button, and permanently accessible templates.

## User Review & Critical Decisions

> [!IMPORTANT]
> The following architectural and user experience decisions have been aligned based on your preferences:

- **Confirmed Decision 1 (App Rebranding to Graphenx)**: Rename the application to **Graphenx** across all UI headers, splash screen, launcher labels (`strings.xml`), project settings (`settings.gradle.kts`), and platform metadata (`metadata.json`).
- **Confirmed Decision 2 (Engine Workspaces)**: Switching engines (Photoshop, Figma, Procreate, Ibis Paint, Krita, FlipaClip) dynamically transforms the toolbars, inspectors, and docks into that specific software's layout while leaving the current canvas content, active layers, and drawing pixels 100% intact.
- **Confirmed Decision 3 (Template Accessibility)**: Surfacing templates through an always-visible sliding dock tab, a prominent top-bar "Templates Hub" quick-launch button, and an instant in-canvas template picker modal so templates are never hidden or lost.
- **Confirmed Decision 4 (Opacity Fade Transitions)**: Adding a linear opacity interpolation toggle between keyframes in the timeline filmstrip with configurable duration and ease-in-out curve.
- **Confirmed Decision 5 (Professional Iconography)**: Stripping all decorative emojis across the interface and replacing them with sharp, studio-grade SVG vector icons and clean typographic labels.
- **Confirmed Decision 6 (Universal Save Icon)**: Adding a standardized universal save icon in the persistent top bar across all engines with tactile visual feedback and timestamp tracking.

---

## 1. Overview & Core Concept

- **What It Does**: Establishes **Graphenx** as a versatile multi-paradigm creative powerhouse. Artists and designers can toggle between **Graphic Design** (Adobe Photoshop or Figma) and **Drawing & Animation** (Procreate, Ibis Paint, Krita, FlipaClip) with dedicated 3-dot engine menus. The timeline gains true frame-to-frame opacity fade tweening, templates are guaranteed accessible at all times, and the entire UI is elevated to a professional vector-styled environment.
- **Target Audience**: Digital painters, vector designers, motion animators, and content creators who frequently switch between raster illustration and UI/graphic design.
- **Key Value**: Eliminates app-switching friction: sketching with Procreate-style gestures, vectoring with Figma tools, animating with FlipaClip onion-skinning, and retouching with Photoshop filters on a single continuous canvas.

---

## 2. User Experience & Visual Design

### Key User Flows

1. **Switching Studio Modes & Engines**:
   - The user looks at the top-right header pod and sees a sleek segmented pill toggle: `[ Graphic Design ] | [ Drawing & Animation ]`.
   - Next to the active segment is a `[ ··· ]` engine menu button.
   - When **Graphic Design** is active, tapping `···` presents:
     - **Adobe Photoshop**: Activates dark carbon styling, Marquee/Lasso/Wand, Dodge/Burn/Smudge toolbar, adjustment layer presets, and layer blend modes.
     - **Figma**: Activates clean slate UI, Frame tool, vector pen path nodes, collaborative cursor layer, and Auto-Layout property inspector.
   - When **Drawing & Animation** is active, tapping `···` presents:
     - **Procreate**: Floating vertical dual-slider dock (Brush Size & Opacity) on the left edge, streamlined minimal header, and quick color disc.
     - **Ibis Paint**: Bottom-docked tool selector, stabilizer slider (0–10), and specialized dip pen / felt tip presets.
     - **Krita**: Docker sidebars, brush preset wheel, and scratchpad canvas.
     - **FlipaClip**: Lower timeline tray with onion skin toggles, frame-by-frame light table, and loop playback.
   - *The user's canvas art, layer stack, and dimensions never reset when engines are switched.*

2. **Universal Save Action**:
   - A dedicated Universal Save button (floppy disc SVG icon with status ring) is anchored in the persistent top bar.
   - Tapping it triggers an instant snapshot save to `localStorage` / project database, flashes a subtle teal ring, and confirms with "Project saved successfully".

3. **Instant Template Browsing & Application**:
   - Always accessible from two permanent access points:
     1. The sliding bottom navigation dock: `Templates` tab.
     2. A top header quick button: `Templates`.
   - Selecting any template (Canva, PhotoRoom, Pinterest, Google) instantly formats the 5-layer editable structure with bounding-box handles and inline text customization.

4. **Timeline Opacity Fade Keyframe Transition**:
   - In the animation timeline, between any two sequential keyframes, the user can tap the transition connector icon `[ ⟐ Fade ]`.
   - When enabled, during animation playback or frame scrubbing, the active layer's opacity linearly interpolates from Frame A's opacity to Frame B's opacity (0% to 100%).

### Visual Identity & Theme

- **Aesthetic Direction**: Studio Dark Mode (`#0d0e15` base, `#161726` elevated glass panels, `#222538` borders).
- **Color Accents by Engine**:
  - Photoshop: Cyan `#00c8ff` & Navy `#001e36`
  - Figma: Purple `#a259ff` & Coral `#f24e1e`
  - Procreate: Neon Orange `#ff6138` & Graphite `#1c1c1e`
  - Ibis Paint: Sky Blue `#0099ff` & Teal `#00e5ff`
  - Krita: Magenta `#f038ff` & Cyan `#38d9ff`
  - FlipaClip: Vivid Red `#ff334b` & Amber `#ffaa00`
- **Iconography**: 100% SVG line and filled vector icons (replacing all emojis) across every menu, tab, card, and action button.
- **Typography**: Clean system sans-serif (`-apple-system`, `Inter`, `Roboto`) with high-contrast hierarchical weights (400, 600, 750, 900).

---

## 3. Key Product Decisions & Trade-Offs

- **Decision 1: Engine Architecture via CSS Viewport Themes & Active Dock Configs**
  - *Chosen Approach*: Maintain a single canvas state machine (`appState.layers`, `appState.canvasDimensions`), while swapping workspace tool palettes and UI modes via an `activeEngine` controller (`'photoshop'`, `'figma'`, `'procreate'`, `'ibispaint'`, `'krita'`, `'flipaclip'`).
  - *Why*: Guarantees zero data loss across engine switches, instant switching performance (<16ms), and avoids memory-heavy DOM rebuilding.
- **Decision 2: Universal Emoji Removal**
  - *Chosen Approach*: Replace all 40+ emojis embedded in shelf headers, buttons, cards, and dialogs with inline SVGs and clean semantic text tags.
  - *Why*: Eliminates the cluttered "hobbyist" aesthetic and satisfies the user's explicit demand for a clean, professional application look.
- **Decision 3: Procedural Opacity Fade Tweening**
  - *Chosen Approach*: Interpolate alpha during composite frame rendering based on normalized sub-frame time or keyframe sequence step without creating destructive flattened bitmaps.
  - *Why*: Preserves full editability of individual layers on each keyframe.
- **Decision 4: Full App Renaming to Graphenx**
  - *Chosen Approach*: Update `metadata.json`, `app/src/main/res/values/strings.xml`, `settings.gradle.kts`, splash screen branding, and document title to **Graphenx**.
  - *Why*: Meets the user's explicit name instruction and satisfies the mandatory AI Studio platform sync rule.

---

## 4. Technical Architecture & Data Strategy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             GRAPHENX WORKSPACE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│  TOP BAR                                                                    │
│  [Universal Save]  [Project Title]   [ Mode: Graphic / Draw ] [ ··· Engine ]│
├───────────────────┬─────────────────────────────────────┬───────────────────┤
│ ENGINE PALETTE    │ CANVAS STAGE (Persistent Data)      │ INSPECTOR / DOCK  │
│                   │                                     │                   │
│ - Photoshop Tools │ ┌─────────────────────────────────┐ │ - Layers / Groups │
│ - Figma Vectors   │ │ Active Composite Viewport       │ │ - Blend Modes     │
│ - Procreate Sliders││ 100% Preserved Across Engines   │ │ - Engine Props    │
│ - Ibis / Krita    │ └─────────────────────────────────┘ │ - Live Transforms │
├───────────────────┴─────────────────────────────────────┴───────────────────┤
│ TIMELINE FILMSTRIP                                                          │
│ [Frame 1] ───[ ⟐ Opacity Fade ]───► [Frame 2] ───[ ⟐ Fade ]───► [Frame 3]   │
├─────────────────────────────────────────────────────────────────────────────┤
│ BOTTOM DOCK (Always Visible)                                                │
│ [ Home ]         [ Templates Hub ]        [ Projects ]        [ Profile ]   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Data Model Additions

```javascript
// Workspace Studio Engine State
appState.workspaceMode = 'design'; // 'design' | 'drawing'
appState.activeEngine = 'photoshop'; // 'photoshop' | 'figma' | 'procreate' | 'ibispaint' | 'krita' | 'flipaclip'

// Timeline Keyframe Transition Model
interface KeyframeTransition {
  fromFrameIndex: number;
  toFrameIndex: number;
  type: 'fade' | 'cut';
  durationMs: number;
  easing: 'linear' | 'ease-in-out';
}
appState.keyframeTransitions = [];
```

### Interactive Component & State Mapping

- `setStudioEngine(mode, engine)`: Updates `workspaceMode` and `activeEngine`, applies CSS engine class to `#app-container`, updates active toolsets, updates left and right docks, and preserves canvas stage.
- `executeUniversalSave()`: Serializes project state, writes to storage, flashes save icon state ring, and displays verification toast.
- `renderTimelineTransitions()`: Renders transition pills between keyframe cards; tapping toggles `opacity_fade`.
- `calculateFrameOpacity(frameIndex, progress)`: In the playback loop, interpolates layer alpha dynamically between bounding frames.
- `openTemplatesModal()` / `switchAppTab('templates')`: Renders templates grid with search, categories, and one-tap canvas loading.
