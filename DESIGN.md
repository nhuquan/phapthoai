# Design System Document: The Digital Sanctuary

## 1. Overview & Creative North Star
This design system is built to transform a standard mobile interface into a "Digital Sanctuary." Moving away from the rigid, grid-heavy constraints of traditional utility apps, this system prioritizes a high-end editorial experience that mirrors the serenity of a meditation hall.

**The Creative North Star: "The Living Manuscript"**
The aesthetic is driven by the concept of ancient wisdom meeting modern clarity. We achieve this through a "Living Manuscript" approach: intentional white space (breathing room), sophisticated serif-to-sans-serif pairings, and an organic flow that mimics the turning of handmade paper. By breaking the "template" look with intentional asymmetry and tonal depth, we ensure the user feels a sense of calm from the moment the interface loads.

---

## 2. Colors: The Muted Palette of Mindfulness
Our palette is rooted in the colors of nature—Sage Green, Soft Lavender, and Pale Yellow—designed to reduce cognitive load and eye strain.

*   **Primary (Sage):** `#3e6848` – Represents growth and the natural world. Used for grounding elements and primary actions.
*   **Secondary (Lavender):** `#615b7a` – Represents the spiritual and the evening sky. Used for secondary navigation and depth.
*   **Tertiary (Yellow):** `#6e5e0e` – Represents enlightenment and warmth. Used for accents and highlights.
*   **Neutral (Surface):** `#f9f9fe` – A cool, off-white that prevents the "starkness" of pure hex white.

### The "No-Line" Rule
To maintain the spiritual softness of the brand, **1px solid borders are strictly prohibited for sectioning.** Boundaries must be defined solely through:
1.  **Background Color Shifts:** Use `surface-container-low` sections sitting on a `surface` background.
2.  **Vertical Space:** Leverage the Spacing Scale (e.g., `spacing-8` or `spacing-10`) to create "invisible" partitions.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers, like stacked sheets of fine vellum. 
*   **Base:** `surface`
*   **Sections:** `surface-container-low`
*   **Interactive Cards:** `surface-container-lowest` (This creates a soft, natural "lift" as the card appears lighter than the background it sits on).

### The "Glass & Gradient" Rule
Floating elements (like a sticky audio player or search bar) should utilize **Glassmorphism**. Apply a semi-transparent `surface` color with a 20px-30px backdrop-blur. For main CTAs, use a subtle linear gradient from `primary` to `primary_container` to provide "soul" and a sense of three-dimensional life.

---

## 3. Typography: Editorial Authority
The typography system uses a high-contrast pairing to balance tradition with modernity.

*   **Display & Headlines (Noto Serif):** Used for wisdom-led content, meditation titles, and editorial headers. The serif conveys authority, history, and the "Plum Village" spirit.
*   **Body & Labels (Plus Jakarta Sans):** Used for functional UI, descriptions, and metadata. This geometric sans-serif provides the "High-End" modern polish required for a seamless digital experience.

**Scale Intent:**
*   `display-lg` (`3.5rem`): Reserved for profound quotes or section landing moments.
*   `title-md` (`1.125rem`): Used for card titles to ensure maximum legibility against soft backgrounds.

---

## 4. Elevation & Depth: Tonal Layering
Traditional material shadows are too "heavy" for a spiritual app. Instead, we use **Tonal Layering**.

*   **The Layering Principle:** Place a `surface-container-lowest` card on top of a `surface-container-low` background. This creates a "soft lift" without a single shadow pixel.
*   **Ambient Shadows:** When a floating effect is required (e.g., a "Now Playing" bar), use an extra-diffused shadow: `blur: 40px`, `y: 8px`, `opacity: 6%`. The shadow color must be a tinted version of `on-surface` (`#2e333a`), never pure black.
*   **The "Ghost Border" Fallback:** If accessibility requires a container boundary, use the `outline-variant` token at **15% opacity**. This creates a "Ghost Border" that defines shape without adding visual noise.

---

## 5. Components: Bespoke Elements

### Cards & Lists
*   **Styling:** Cards should use the `xl` (`1.5rem`) corner radius.
*   **Anti-Pattern:** Forbid the use of divider lines. Separate list items using `spacing-3` vertical gaps or alternating subtle tints between `surface` and `surface-container-low`.
*   **The Timeline Node:** As seen in the reference, use the `tertiary_fixed` (`#fce589`) for chronological indicators, creating a "Sunlight" effect along the user's journey.

### Buttons
*   **Primary:** High-pill shape (`rounded-full`). Gradient of `primary` to `primary_dim`. Text in `on_primary`.
*   **Secondary:** `secondary_container` background with `on_secondary_container` text. No border.
*   **Ghost:** Text-only using `primary` color, reserved for low-priority actions like "Cancel" or "Back."

### Input Fields (Search)
*   **Style:** `rounded-full` with a `surface-container-highest` background. 
*   **Iconography:** Use `outline` (`#777b83`) for icons to ensure they feel "etched" rather than "stamped" on the interface.

### The Audio Timeline (Special Component)
In a meditation context, the progress bar should feel organic. Use a `primary_container` track with a `primary` weighted handle. The "active" state of a track should glow slightly using a 10% opacity `primary` shadow.

---

## 6. Do's and Don'ts

### Do
*   **DO** use `spacing-12` or `spacing-16` for page margins to create a high-end, "Gallery" feel.
*   **DO** use Noto Serif for all content that is meant to be "absorbed" (quotes, teachings).
*   **DO** use `surface-bright` for the most important interactive elements to draw the eye naturally.

### Don't
*   **DON'T** use `error` red for anything other than critical destructive actions. For "warnings," use a muted `tertiary`.
*   **DON'T** use 100% opaque black for text. Always use `on_surface` (`#2e333a`) to keep the contrast "Zen-friendly."
*   **DON'T** use sharp 0px or 4px corners. Every element should feel tumbled and soft, like a river stone (`rounded-lg` or higher).

### Accessibility Note
While the palette is muted, always ensure that text on `surface-container` tiers meets WCAG AA contrast ratios by defaulting to the `on_surface` or `on_surface_variant` tokens.