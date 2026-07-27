import AppKit

final class StatusBarController: NSObject {
    private static let shortcutEnabledKey = "shortcutEnabled"

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let menu = NSMenu()
    private var selectedMode: CaptureMode
    private var modeItems: [CaptureMode: NSMenuItem] = [:]
    private var hotKeyController: HotKeyController?
    private var shortcutEnabledItem: NSMenuItem?
    private var launchAtLoginItem: NSMenuItem?
    private var isShortcutEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: Self.shortcutEnabledKey) == nil {
                return true
            }

            return UserDefaults.standard.bool(forKey: Self.shortcutEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.shortcutEnabledKey)
        }
    }

    override init() {
        selectedMode = CaptureMode.savedMode()
        super.init()
        configureStatusItem()
        configureMenu()
        LoginItemController.applySavedPreference()
        hotKeyController = HotKeyController(isEnabled: isShortcutEnabled) { [weak self] in
            self?.runSelectedMode()
        }
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else {
            return
        }

        button.image = NSImage(systemSymbolName: "camera", accessibilityDescription: "QuickCapture")
        button.image?.isTemplate = true
        button.target = self
        button.action = #selector(statusItemClicked(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.toolTip = tooltipText
    }

    private func configureMenu() {
        for mode in CaptureMode.allCases {
            let item = NSMenuItem(
                title: mode.menuTitle,
                action: #selector(selectCaptureMode(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = mode.rawValue
            menu.addItem(item)
            modeItems[mode] = item
        }

        menu.addItem(.separator())

        let launchItem = NSMenuItem(
            title: "로그인 시 자동 실행",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchItem.target = self
        menu.addItem(launchItem)
        launchAtLoginItem = launchItem

        let shortcutItem = NSMenuItem(
            title: "Option-X 단축키 사용",
            action: #selector(toggleShortcutEnabled),
            keyEquivalent: ""
        )
        shortcutItem.target = self
        menu.addItem(shortcutItem)
        shortcutEnabledItem = shortcutItem

        let hotKeyItem = NSMenuItem(title: "단축키: Option-X", action: nil, keyEquivalent: "")
        hotKeyItem.isEnabled = false
        menu.addItem(hotKeyItem)

        let screenCaptureSettingsItem = NSMenuItem(
            title: "화면 기록 설정 열기",
            action: #selector(openScreenCaptureSettings),
            keyEquivalent: ""
        )
        screenCaptureSettingsItem.target = self
        menu.addItem(screenCaptureSettingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "QuickCapture 종료",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        updateMenuState()
    }

    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            return
        }

        switch event.type {
        case .rightMouseUp:
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height + 4), in: sender)
        default:
            runSelectedMode()
        }
    }

    @objc private func selectCaptureMode(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let mode = CaptureMode(rawValue: rawValue)
        else {
            return
        }

        selectedMode = mode
        selectedMode.save()
        updateMenuState()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    @objc private func toggleLaunchAtLogin() {
        LoginItemController.isEnabled.toggle()
        updateMenuState()
    }

    @objc private func toggleShortcutEnabled() {
        isShortcutEnabled.toggle()
        hotKeyController?.setEnabled(isShortcutEnabled)
        updateMenuState()
    }

    @objc private func openScreenCaptureSettings() {
        CaptureRunner.openScreenCaptureSettings()
    }

    private func updateMenuState() {
        for (mode, item) in modeItems {
            item.state = mode == selectedMode ? .on : .off
        }

        launchAtLoginItem?.state = LoginItemController.isEnabled ? .on : .off
        shortcutEnabledItem?.state = isShortcutEnabled ? .on : .off
        statusItem.button?.toolTip = tooltipText
    }

    private func runSelectedMode() {
        CaptureRunner.run(selectedMode)
    }

    private var tooltipText: String {
        if isShortcutEnabled {
            return "QuickCapture: \(selectedMode.title)\n단축키: Option + X"
        }

        return "QuickCapture: \(selectedMode.title)\n단축키: 사용 안 함"
    }
}
