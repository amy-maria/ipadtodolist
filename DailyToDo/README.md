# DailyToDo

    A daily planner app for iPad, built with SwiftUI. 
    Recreates a physical "Today" desk-pad layout — a main checklist, top priorities, a tomorrow list, and a notes area — with full support for hardware keyboard navigation and Apple Pencil.

## Features

- **Daily checklist** — main task list, top priorities, and a tomorrow section, each with tappable checkboxes and editable text.
- **Keyboard navigation** — Tab moves between fields natively; Return chains through every field in page order (Main List → Priorities → Tomorrow → Notes).
- **Apple Pencil support** — a toggleable full-page ink layer (Draw mode / Type mode, switched via the header button) lets you circle, cross out, or annotate anywhere on the page. Scribble (handwriting-to-text) works automatically in every text field.
- **Dark theme** — custom dark color palette, forced app-wide via `.preferredColorScheme(.dark)`.
- **New Day** — archives the current page into history and starts a fresh blank page, with a confirmation prompt.
- **History** — browse up to 7 days of past pages (read-only), including labeled snapshots of handwritten ink grouped by which section of the page they were drawn in. Older entries are pruned automatically.
- **Auto-save** — every change (text, checkboxes, ink) is saved to disk automatically; no manual save needed.

## Requirements

- Xcode (a recent version supporting iPadOS 26+ as a build target)
- An iPad running iPadOS 26 or later
- Apple Pencil (optional — the app is fully usable with just a keyboard/finger, but ink features require a Pencil)

## Getting Started

1. Clone this repository and open `DailyToDo.xcodeproj` in Xcode.
2. Select your iPad as the run destination (or a matching iPad simulator).
3. Build and run (**Cmd+R**).

To run on a physical iPad, you'll need to sign the app with your Apple ID under **Signing & Capabilities** in the project settings. With a free Apple ID, the signing certificate expires every 7 days and the app will need to be rebuilt from Xcode to keep working; an Apple Developer Program membership removes this limitation and enables TestFlight distribution.

## Project Structure

| File | Purpose |
|---|---|
| `DailyToDoApp.swift` | App entry point; creates the shared `DayStore`. |
| `ContentView.swift` | Main screen layout — header, checklist, priorities, tomorrow, notes. |
| `TaskItem.swift` | Model for a single checklist row (title + done state). |
| `DayPlan.swift` | Model for one full day's page (all lists, notes, ink drawing, section layout info). |
| `DayStore.swift` | Loads/saves data to disk, manages today's page and archived history. |
| `TaskRowView.swift` | Reusable checkbox + text row, used by the Main List and For Tomorrow sections. |
| `Field.swift` | Enum identifying every focusable field, used for keyboard navigation. |
| `PencilOverlayView.swift` | The Apple Pencil ink layer (PencilKit integration). |
| `SectionFramePreferenceKey.swift` | Tracks each section's on-screen position, used to label ink by location in History. |
| `HistoryListView.swift` | List of past archived days. |
| `HistoryDayView.swift` | Read-only detail view for a single past day. |

## Known Limitations

- **Portrait, full-screen only** — the app locks orientation and disables iPad Split View/Slide Over. This is intentional: the ink layer's coordinates don't automatically rescale with a reflowing layout, so a fixed layout keeps everything aligned.
- **7-day history retention** — archived days older than 7 days are deleted automatically (configurable via `retentionDays` in `DayStore.swift`).
- **Past days are read-only** — you can view but not edit archived days.
