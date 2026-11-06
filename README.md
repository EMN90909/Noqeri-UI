# Noqeri UI

A **Noqeri-native UI system** combining **106 Noqeri UI components** with **20 Noqeri core components**, plus five pinned and directly imported native libraries from [Noqeri Registry](https://github.com/EMN90909/noqeri-registry).

**No JavaScript, TypeScript, Node.js, npm or frontend runtime dependency** is used to build the native static pages or perform the server-driven demo actions. No JSX, React or CSS framework required. The native compiler generates browser-standard HTML and CSS.

> Release: **0.2.1 experimental**. Native Noqeri component rendering is presently a C++ bootstrap feature. True `import "noqeri/components"` resolution in the native web DSL is **not yet supported**. The supported approach uses Noqeri's `NOQERI_WEB_UI_PATH` to load the component bundle. The CLI, registry utility imports and compiler are distinct language frontends.

## Build a static Noqeri UI site

Build [Noqeri](https://github.com/EMN90909/Noqeri)'s native compiler first:

```sh
cmake -S ../Noqeri -B ../Noqeri/build -DCMAKE_BUILD_TYPE=Release -DNOQERI_GRAPHICS_PORTABLE_BUILD=ON
cmake --build ../Noqeri/build --target noqeri-web noqeri -j2

NOQERI_SOURCE=../Noqeri bash scripts/native.sh build ./dist/native
# Or compile your own application using the same Noqeri UI components:
NOQERI_SOURCE=../Noqeri bash scripts/native.sh build ./dist/my-app ./my-app/main.noqeri
```

The output includes `index.html`, `components/index.html`, `forms/index.html` and `theme.css`. Serve the directory from any static host. There are **no generated JavaScript files**.

For a fully native no-JavaScript action server **on localhost only**:

```sh
NOQERI_SOURCE=../Noqeri bash scripts/native.sh serve 8080
# Serve your own Noqeri application with native form/button actions:
NOQERI_SOURCE=../Noqeri bash scripts/native.sh serve 8080 ./my-app/main.noqeri
```

`serve-app` runs a native server with regular HTML POSTs, CSRF protection and per-session state. It is an experimental **local development server**, not production-hardened.

## Component example

The `NOQERI_WEB_UI_PATH` loader assembles Noqeri's existing UI (`Core*` names) plus the Noqeri-UI definitions. App code uses the supported core import syntax:

```noqeri
import "noqeri/ui" as ui

route "/" {
    main class: "nui-root" {
        div class: "nui-container nui-stack" {
            ui.CoreHeading("Hello from Noqeri core")
            ui.PageHeader("WELCOME", "Noqeri UI", "Built without JavaScript")
            ui.Card("Native UI", "Responsive styles and semantic HTML")
            ui.AccordionItem("FAQ", "Browser-native disclosure")
            ui.BadgeSuccess("Ready")
        }
    }
}
```

To build your own app, pass the directory containing `main.noqeri` or the `.noqeri` source file as the third argument. The script injects the UI stylesheet using native `style """..."""` syntax. See `examples/native-actions/main.noqeri` for genuinely functional server-driven form and button actions.

## Imported ecosystem libraries

Ordinary Noqeri source `src/ecosystem.noqeri` **imports and wraps** the pinned `.noqeri` files:

| Source | Pinned | Implemented native functions |
|---|---|---|
| `noqeri/dom` | 0.1.1 | `uiValidId`, `uiValidTag` |
| `noqeri/html` | 0.1.1 | `uiEscapedSize`, `uiEscapeText`, `uiValidAttribute` |
| `noqeri/tailwind` | 0.1.1 | `uiValidClass`, `uiClassVariantCount`, `uiClassJoin` |
| `noqeri/router` | 0.1.1 | `uiValidRoute`, `uiRouteMatches` |
| `noqeri/json` | 0.1.1 | `uiValidJsonNumber`, `uiJsonQuote` |

These are **native language helpers**. The Tailwind registry module validates class names; it is not the Tailwind CSS framework. The DOM module exposes extern host calls, but the library does not claim a browser DOM host is available without wiring it up. Browser markup is rendered by Noqeri's native web compiler.

The package manifest pins these dependencies and vendor copies are checked against their registry sources in CI. The reused original modules are MIT licensed, with upstream attribution in `vendor/README.md`.

## Components and design

All 106 native components in `src/components.noqeri` are available through the assembled library, plus the `Core*` prefixed copies of the 20 existing `Lib/web/ui.noqeri` components. See [component inventory](docs/COMPONENTS.md) and [design system](docs/DESIGN_SYSTEM.md). Design uses CSS custom properties, responsive layout utilities, focus visibility, semantic form elements, dark mode variables and reduced-motion handling.

Native-only interactions now include accessible disclosure panels, CSS-only color-mode selection, a mobile navigation menu, breadcrumbs and pagination. A real button/form server-action POST regression verifies state changes and CSRF replay rejection.

Not claimed: client-only reactive dialogs, custom focus traps, portalled popovers, keyboard-complete comboboxes or arbitrary component event callbacks. Static `Button()` displays a button, but to make an action work in native server mode use a native `button on.click` in your view.

## Test

```sh
NOQERI_SOURCE=../Noqeri bash scripts/test-native.sh
```

CI runs Noqeri's actual native compiler, validates output contains no JavaScript, tests registry helper imports and checks compiler compatibility.

## Registry

Package: `noqeri/components@0.2.1`. The registry is source-index-backed; this release is published by committing versioned package contents and the index entry. **Package installation alone does not yet resolve native web component imports.** Use the native bundling approach above until that compiler limitation is addressed.

## Licensing

New Noqeri-UI components and styles: MIT (`LICENSE`). Registry modules: MIT per upstream license. Noqeri core UI components are loaded from the installed Noqeri compiler source at build time and remain **Apache-2.0**. Do not relicense core sources when redistributing compiled or combined libraries.
