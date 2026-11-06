# Noqeri UI

A native **Noqeri-authored** component system for Noqeri's experimental browser-view compiler. No React, JSX, or npm runtime dependencies.

**102 components** across typography, actions, surfaces, forms, navigation, feedback, data displays, and accessible native interactions, with responsive CSS tokens, light/dark support, examples, and CI.

> Release status: **experimental**. The Noqeri browser-view compiler is not the Stage-2 typed frontend, and Noqeri's static native web compiler cannot currently resolve arbitrary local package imports. This package does **not** promise Mantine/shadcn feature parity or production-grade overlays.

## Quick start (Noqeri browser views)

Recommended: use the registry installer, which calls Noqeri's verified package manager, installs the source, links CSS, and preserves existing styles:

```sh
NOQERI_REPO=/path/to/Noqeri node /path/to/Noqeri-UI/scripts/install.mjs ./my-app
```

For manual installation, place `src/components.noqeri` at `noqeri/components.noqeri`, and `styles.css` in your application root. The web-view builder must see both assets under the project root.

```noqeri
import "noqeri/components" as ui

view {
    main class: "nui-root" {
        div class: "nui-container nui-stack" {
            ui.PageHeader("WELCOME", "Noqeri UI", "Build interfaces in Noqeri.")
            ui.Card("Ready", "Styled, semantic, dependency-free.")
            ui.AccordionItem("Show details", "Browser-native disclosure.")
        }
    }
}
```

Build with the Noqeri repo (Node.js 22+): `node /path/to/Noqeri/Runtime/web-project.mjs ./app ./dist`. Or, where supported, `noqeri web-project ./app ./dist`.

### Registry

Package identity: `noqeri/components@0.1.0` in [Noqeri Registry](https://github.com/EMN90909/noqeri-registry). Current registry is catalog-backed and read-only: publication requires a versioned package directory and an entry in `registry/index.json`, not an HTTP upload. Archive download is at `/v1/packages/noqeri/components/0.1.0/download` once the registry is redeployed.

Registry package archive contains `src/components.noqeri` and `styles.css`; copy them to the paths above until the language's package manager wires browser-view package imports automatically.

## Component APIs

- Typography: Heading, Heading2, Heading3, Eyebrow, Text, Lead, MutedText, Caption, InlineCode, KeyboardKey, Quote.
- Controls: Button, SubmitButton, SecondaryButton, OutlineButton, GhostButton, DangerButton, SmallButton, LinkButton, NavLink, SidebarLink.
- Feedback: Badge variants, Alert variants, ErrorSummary, EmptyState, Spinner, SkeletonText, SkeletonCard, Progress variants.
- Layouts: Card, CardWithFooter, Panel, Paper, FeatureCard, PageHeader, Hero, SectionHeading, StatCard, Metric, Step, TimelineItem.
- Forms: Field, RequiredField, EmailField, PasswordField, NumberField, PhoneField, SearchField, DateField, FileField, TextAreaField, Checkbox, Radio, Switch, SelectTwo, SelectThree.
- Native interaction: Disclosure and AccordionItem (HTML `details`/ `summary`).
- Data: DescriptionItem, DataRow, TableRow2/3, TableHeader2/3, TableCaption.

See [component reference](docs/COMPONENTS.md) and [design system](docs/DESIGN_SYSTEM.md).

## Theming

Set Noqeri's `theme { primary: "#..." }` values, override `--nui-*` CSS custom properties, or wrap a section with `nui-theme-dark`. Add the `nui-root` class to the page root. CSS utilities: `nui-container`, `nui-grid`, `nui-grid-2`, `nui-grid-3`, `nui-stack`, `nui-group`, `nui-between`, `nui-navbar`, `nui-table`.

## Interactivity and limitations

The Noqeri view compiler accepts event handlers on **native elements**, not as callbacks passed through arbitrary components. For an action, use a native `button class: "nui-button" on.click { ... }`. `Button()` is intended for non-bound actions, and does not attach handlers by itself.

Semantic `details`, `summary`, form controls and route links are interactive without custom components. `TabButton`/`TabSelected` are visual primitives only, **not a complete ARIA tab pattern**; do not use them as an accessible tab system until keyboard navigation and focus behavior are implemented. No Modal/Dialog, Combobox, DatePicker popup, Toast manager, Portal, virtualized DataGrid, or focus-trap is claimed. Those require compiler/runtime capability work and cross-browser tests.

## Test

```sh
NOQERI_REPO=/path/to/Noqeri node --test tests/ui-contract.mjs
NOQERI_REPO=/path/to/Noqeri node --test tests/install.test.mjs\nNOQERI_REPO=/path/to/Noqeri node scripts/build-showcase.mjs
```

This suite builds and imports the generated Noqeri views and validates component coverage. CI checks out Noqeri and tests the real compiler. License: MIT.
