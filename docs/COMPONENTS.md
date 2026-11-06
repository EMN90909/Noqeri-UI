# Component reference

## Native loader

`scripts/native.sh` loads 106 `src/components.noqeri` components plus 19 prefixed `Core*` components from the Noqeri language repository's `Lib/web/ui.noqeri`. No JavaScript is bundled or required. The exposed namespace is `import "noqeri/ui" as ui`; the native compiler does not yet resolve `noqeri/components` from a registry package directly.

## Core Noqeri UI exports

`CoreHeading`, `CoreLead`, `CoreCard`, `CoreBadge`, `CoreNotice`, `CoreButton`, `CoreLinkButton`, `CoreNavLink`, `CoreTextField`, `CoreStatistic`, `CorePageHeader`, `CoreSectionHeading`, `CorePanel`, `CoreEmptyState`, `CoreFieldHint`, `CoreFieldError`, `CoreSecondaryLink`, `CoreFooterNote`, `CoreSubmitButton`, `CoreTextAreaField`.

Core component names are generated with a `Core` prefix. There are **20 names in the installed core library** (not 19). If core exports change in a future Noqeri revision, this count may change.

## Native Noqeri UI components

All 106 APIs live in [src/components.noqeri](../src/components.noqeri), including Button variants, Typography, Field/Input variants, accessible native details and summary, Progress, DataRows, Tables, Alerts and stat cards. Styling is in `styles.css`.

### Server-driven interactions

Do not mistake static visual primitives for stateful components. Noqeri native `serve-app` handles actions through HTML POST requests:

```noqeri
let count = 0
route "/" {
    main {
        ui.CoreHeading("Counter")
        p { "Count: " + count }
        button class: "nui-button" on.click { count = count + 1 } { "Increment" }
    }
}
```

Use a native `form on.submit` and server-side validation for forms. The native web host does not yet accept arbitrary event callbacks in reusable components.

## Accessible patterns

Semantic HTML input/label associations, default keyboard-native `details` toggles, focus-visible CSS, reduced-motion handling and low-motion states are included. Visual tabs alone do not provide WAI-ARIA keyboard navigation, so `TabButton` and `TabSelected` are styling primitives, not a claimed complete tab system.

## Registry native functions

`src/ecosystem.noqeri` imports three pinned modules: `dom`, `html`, `tailwind`. Validations are ordinary compiled Noqeri functions and are tested independently from the web view DSL. Client DOM host externs remain unsupported in the native web static path.

## Added native patterns

`ColorModeToggle(label, fieldId)` switches its enclosing `.nui-root` light/dark tokens using browser-native checkbox state and CSS `:has()`, no JavaScript. `MobileMenu(homeHref, componentsHref, formsHref)` uses `<details>` and keyboard-operable `<summary>`. `Breadcrumbs2` and `Pagination3` use semantic navigation and real links. These are intentionally bounded patterns rather than arbitrary-component child slots.

Native registry functions now also import `noqeri/router@0.1.1` and `noqeri/json@0.1.1` for route and JSON validation.
