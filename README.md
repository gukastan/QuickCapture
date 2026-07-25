# QuickCapture

QuickCapture is a tiny macOS menu bar app that turns the built-in screenshot tool into a one-click action.

It is intentionally small: no editor, no cloud sync, no account, no tracking. Pick a capture mode from the menu bar once, then run it again with a left click or `Option + C`.

## Features

- Menu bar camera icon
- Left click runs the currently selected screenshot mode
- Right click opens the mode menu and app controls
- Global shortcut: `Option + C`
- Remembers the selected mode with `UserDefaults`
- Launches at login, with a menu toggle to turn that off
- Runs without a Dock icon
- Opens Screen Recording settings from the menu when permission needs attention
- Uses macOS's built-in `/usr/sbin/screencapture` command instead of a custom capture engine

## Capture Modes

- Area capture -> save file
- Area capture -> clipboard
- Window capture -> clipboard
- Full screen -> clipboard

The default mode is `Area capture -> clipboard`, which is convenient for pasting screenshots directly into chat, Slack, documents, or issue trackers.

## Requirements

- macOS 13 or later
- Xcode 16.4 or later for building from source
- Intel Mac supported
- Apple Silicon Mac usually works through Rosetta when using an Intel build; build as Universal for native Intel + Apple Silicon distribution

This project was originally built and tested on an Intel Mac running macOS 15.7.7 with Xcode 16.4.

## Download

Prebuilt app zips are available from the GitHub Releases page.

The release build is intentionally not signed with a paid Apple Developer certificate and is not notarized by Apple. This keeps the project simple and personal, but it also means macOS may show an "unidentified developer" warning the first time you open the app.

If macOS blocks the app:

1. Move `QuickCapture.app` to `/Applications`.
2. Control-click `QuickCapture.app`.
3. Choose `Open`.
4. Confirm that you want to open it.

You only need to do this manual open step once per downloaded build.

## Build And Run

1. Open `QuickCapture.xcodeproj` in Xcode.
2. Select the `QuickCapture` scheme.
3. Press Run.
4. Look for the camera icon in the right side of the menu bar.
5. Right click the camera icon and choose a capture mode.
6. Left click the icon, or press `Option + C`, to run the selected mode.

For everyday use, build the app and move `QuickCapture.app` into `/Applications`. Keeping the app in one stable location helps macOS remember screen recording permission correctly.

## Install For Daily Use

After building in Xcode:

1. Open the build product in Finder.
2. Move `QuickCapture.app` to `/Applications`.
3. Open it from `/Applications`.
4. Give Screen Recording permission when macOS asks.
5. Quit and reopen QuickCapture once after permission is granted.

Avoid running different copies of the app from multiple folders. macOS privacy permissions are tied to the app bundle, and multiple copies can make permission prompts feel stuck.

## Permissions

macOS may ask for screen recording permission the first time QuickCapture runs a screenshot.

If capture does not work:

1. Open System Settings.
2. Go to Privacy & Security.
3. Open Screen & System Audio Recording or Screen Recording.
4. Enable QuickCapture.
5. Quit and reopen QuickCapture.

You can also right click the menu bar icon and choose `Open Screen Recording Settings`.

If permission prompts keep repeating, make sure you are only running `/Applications/QuickCapture.app`, not an Xcode DerivedData build or another copied app bundle. During development, resetting the app's Screen Recording entry and then launching only the `/Applications` copy usually fixes repeated prompts.

## File Output

`Area capture -> save file` saves screenshots to the Desktop with names like:

```text
QuickCapture_2026-07-25_20-31-42.png
```

Clipboard modes place the captured image on the system clipboard so it can be pasted with `Command + V`.

## Project Structure

```text
QuickCapture/
├── QuickCapture.xcodeproj
├── QuickCapture/
│   ├── AppDelegate.swift
│   ├── CaptureMode.swift
│   ├── CaptureRunner.swift
│   ├── HotKeyController.swift
│   ├── Info.plist
│   ├── LoginItemController.swift
│   ├── StatusBarController.swift
│   └── main.swift
├── LICENSE
└── README.md
```

## How It Works

QuickCapture is an AppKit menu bar app built around `NSStatusItem`.

- `StatusBarController.swift` manages the camera icon, left click, right click menu, and tooltip.
- `CaptureMode.swift` defines the four screenshot modes and persists the selected mode.
- `CaptureRunner.swift` launches macOS's built-in `screencapture` command.
- `HotKeyController.swift` registers the global `Option + C` shortcut.
- `LoginItemController.swift` registers launch-at-login behavior with `ServiceManagement`.
- `Info.plist` sets `LSUIElement` so the app stays out of the Dock.

## Forking

Forks are welcome. You may fork this project, modify it for your own workflow, and redistribute your version under the MIT license.

This project is intentionally simple so it is easy to adapt:

- change the shortcut
- add more capture modes
- add custom save folders
- build a Universal binary
- redesign the menu bar icon
- remove launch-at-login if you prefer manual startup

If you fork it, a short credit or link back is appreciated but not required by the license.

## License

MIT. You can use, fork, modify, and redistribute this project.
