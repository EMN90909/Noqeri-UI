# Component reference

## Contract

Components are authored as `component Name(parameter: string) { ... }` with one or more semantic DOM nodes. Most input params are strings. Literal class names are deliberate public extension points. The browser-view compiler escapes text and attributes. Interactive state/actions are authored in the calling view.

## Exports (102)

- `Heading(text: string)`
- `Heading2(text: string)`
- `Heading3(text: string)`
- `Eyebrow(text: string)`
- `Text(text: string)`
- `Lead(text: string)`
- `MutedText(text: string)`
- `Caption(text: string)`
- `InlineCode(text: string)`
- `KeyboardKey(text: string)`
- `Quote(text: string)`
- `Strong(text: string)`
- `FieldHelp(text: string)`
- `FieldError(text: string)`
- `Badge(text: string)`
- `BadgeSuccess(text: string)`
- `BadgeWarning(text: string)`
- `BadgeDanger(text: string)`
- `BadgeInfo(text: string)`
- `Chip(text: string)`
- `Avatar(text: string)`
- `Tag(text: string)`
- `FooterNote(text: string)`
- `ListItem(text: string)`
- `TableCaption(text: string)`
- `BreadcrumbCurrent(text: string)`
- `Loading(text: string)`
- `HelpText(text: string)`
- `MenuHeading(text: string)`
- `DialogExplanation(text: string)`
- `Button(label: string)`
- `SubmitButton(label: string)`
- `SecondaryButton(label: string)`
- `OutlineButton(label: string)`
- `GhostButton(label: string)`
- `DangerButton(label: string)`
- `SmallButton(label: string)`
- `DisabledButton(label: string)`
- `TabButton(label: string)`
- `TabSelected(label: string)`
- `LinkButton(label: string, href: string)`
- `SecondaryLink(label: string, href: string)`
- `NavLink(label: string, href: string)`
- `SidebarLink(label: string, href: string)`
- `BreadcrumbLink(label: string, href: string)`
- `PaginationLink(label: string, href: string)`
- `InlineLink(label: string, href: string)`
- `CardLink(label: string, href: string)`
- `Card(title: string, description: string)`
- `CardWithFooter(title: string, description: string, footer: string)`
- `Panel(title: string, description: string)`
- `Paper(title: string, description: string)`
- `FeatureCard(eyebrow: string, title: string, description: string)`
- `StatCard(label: string, value: string, detail: string)`
- `Metric(label: string, value: string)`
- `PageHeader(eyebrow: string, title: string, description: string)`
- `Hero(eyebrow: string, title: string, description: string)`
- `SectionHeading(title: string, description: string)`
- `ToolbarTitle(title: string, description: string)`
- `AvatarName(initials: string, name: string)`
- `Alert(title: string, description: string)`
- `AlertSuccess(title: string, description: string)`
- `AlertWarning(title: string, description: string)`
- `AlertDanger(title: string, description: string)`
- `AlertInfo(title: string, description: string)`
- `EmptyState(title: string, description: string)`
- `Callout(title: string, message: string)`
- `ErrorSummary(title: string, message: string)`
- `SkeletonText()`
- `SkeletonCard()`
- `Spinner(label: string)`
- `Divider()`
- `SectionDivider()`
- `Disclosure(title: string, content: string)`
- `AccordionItem(title: string, content: string)`
- `Step(number: string, title: string, description: string)`
- `TimelineItem(date: string, title: string, description: string)`
- `DescriptionItem(term: string, value: string)`
- `DataRow(label: string, value: string)`
- `TableRow2(first: string, second: string)`
- `TableRow3(first: string, second: string, third: string)`
- `TableHeader2(first: string, second: string)`
- `TableHeader3(first: string, second: string, third: string)`
- `Field(labelText: string, fieldId: string, placeholderText: string)`
- `EmailField(labelText: string, fieldId: string)`
- `PasswordField(labelText: string, fieldId: string)`
- `NumberField(labelText: string, fieldId: string)`
- `SearchField(labelText: string, fieldId: string)`
- `PhoneField(labelText: string, fieldId: string)`
- `DateField(labelText: string, fieldId: string)`
- `FileField(labelText: string, fieldId: string)`
- `RequiredField(labelText: string, fieldId: string, placeholderText: string)`
- `TextAreaField(labelText: string, fieldId: string, placeholderText: string)`
- `Checkbox(labelText: string, fieldId: string)`
- `Radio(labelText: string, fieldId: string, groupName: string)`
- `Switch(labelText: string, fieldId: string)`
- `SelectTwo(labelText: string, fieldId: string, optionOne: string, optionTwo: string)`
- `SelectThree(labelText: string, fieldId: string, optionOne: string, optionTwo: string, optionThree: string)`
- `ProgressQuarter(label: string)`
- `ProgressHalf(label: string)`
- `ProgressThreeQuarters(label: string)`
- `ProgressComplete(label: string)`

## Composition

Use Noqeri-native elements when flexible children or event handlers are needed:

```noqeri
view {
    div class: "nui-stack" {
        ui.Card("Project", "Ready")
        button class: "nui-button" type: "button" on.click { count = count + 1 } { "Add" }
        table class: "nui-table" {
            thead { ui.TableHeader2("Task", "Status") }
            tbody { ui.TableRow2("Deployment", "Healthy") }
        }
    }
}
```

Use standard HTML elements for complex form structures. For lists, compose `ul` with `li`. For tabs, use native buttons and conditional view state only after implementing correct WAI-ARIA keyboard behavior; visual helpers are not a replacement.
