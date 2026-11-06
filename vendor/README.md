# Pinned Noqeri Registry modules

The source files under `vendor/noqeri/` are from [EMN90909/noqeri-registry](https://github.com/EMN90909/noqeri-registry) at **version 0.1.1**:

- `dom/dom.noqeri` copied from `packages/noqeri/dom/0.1.1/src/dom.noqeri`
- `html/html.noqeri` copied from `packages/noqeri/html/0.1.1/src/html.noqeri`
- `tailwind/tailwind.noqeri` copied from `packages/noqeri/tailwind/0.1.1/src/tailwind.noqeri`
- `router/router.noqeri` copied from `packages/noqeri/router/0.1.1/src/router.noqeri`
- `json/json.noqeri` copied from `packages/noqeri/json/0.1.1/src/json.noqeri`

All five originals have MIT licenses. The original module comments and module paths are preserved. The root LICENSE applies to new code and these redistributed MIT sources. CI compares source bytes with the pinned registry paths and will fail if a future change silently diverges.

**Important:** The Noqeri native web DSL only imports its built-in `noqeri/ui` namespace. The above modules are real ordinary Noqeri imports in `src/ecosystem.noqeri`, not browser component imports. In particular the DOM source declares host extern functions, not a full browser integration, and the Tailwind source provides validation rather than Tailwind CSS styles.

The Noqeri core `Lib/web/ui.noqeri` is loaded from Noqeri at build time and has **Apache-2.0**, not MIT, licensing.
