# Noqeri UI design contract

- Defaults: graphite text, white surfaces, soft slate borders, configurable primary (Noethric orange shown in the example), clean system typography.
- Tokens: `--nui-primary`, `--nui-primary-hover`, `--nui-surface`, `--nui-background`, `--nui-text`, `--nui-muted`, `--nui-border`, `--nui-radius`, `--nui-radius-sm`, `--nui-radius-lg`, `--nui-ring`.
- Universal focus: `:focus-visible` outlines; hover never substitutes for keyboard focus.
- Accessible by default: native form labels, status/alert roles, reduced-motion CSS, semantic links, native details/summary toggles.
- Responsive utilities: 720px breakpoint collapses grids and adjusts spacing. No viewport-height-dependent UI logic.
- Typography: use `nui-h1`, `nui-h2`, `nui-h3`, `nui-muted`, and `nui-lead`.
- Dark mode: an ancestor with `nui-theme-dark` overrides background/surface/text/border tokens. Note that CSS dark-mode badge tones are tuned for readable color combinations but must be audited on all browser/color configurations.

## Exclusions and known gaps

The current Noqeri view parser does not expose general component child slots, arbitrary event props, `dialog`, `popover`, generic CSS style attributes, a complete listbox/combobox primitive, or robust runtime portal/focus-trap support. We intentionally do not fake these with a styled static div. Advanced interactions await compiler extensions and browser tests.
