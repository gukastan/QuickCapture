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
        let captureActionHeader = NSMenuItem(
            title: "좌클릭·option + X 실행 동작",
            action: nil,
            keyEquivalent: ""
        )
        captureActionHeader.isEnabled = false
        menu.addItem(captureActionHeader)

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

        let appSettingsHeader = NSMenuItem(
            title: "앱 설정",
            action: nil,
            keyEquivalent: ""
        )
        appSettingsHeader.isEnabled = false
        menu.addItem(appSettingsHeader)

        let launchItem = NSMenuItem(
            title: "Mac 로그인 시 QuickCapture 자동 시작",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchItem.target = self
        menu.addItem(launchItem)
        launchAtLoginItem = launchItem

        let shortcutItem = NSMenuItem(
            title: "전역 실행 단축키 사용 (option + X)",
            action: #selector(toggleShortcutEnabled),
            keyEquivalent: ""
        )
        shortcutItem.target = self
        menu.addItem(shortcutItem)
        shortcutEnabledItem = shortcutItem

        menu.addItem(.separator())

        let permissionHeader = NSMenuItem(
            title: "권한 및 문제 해결",
            action: nil,
            keyEquivalent: ""
        )
        permissionHeader.isEnabled = false
        menu.addItem(permissionHeader)

        let screenCaptureSettingsItem = NSMenuItem(
            title: "화면 캡처 권한 설정 열기… (시스템 설정)",
            action: #selector(openScreenCaptureSettings),
            keyEquivalent: ""
        )
        screenCaptureSettingsItem.target = self
        menu.addItem(screenCaptureSettingsItem)

        let resetScreenCapturePermissionItem = NSMenuItem(
            title: "화면 캡처 권한 다시 설정… (문제 발생 시)",
            action: #selector(resetScreenCapturePermission),
            keyEquivalent: ""
        )
        resetScreenCapturePermissionItem.target = self
        menu.addItem(resetScreenCapturePermissionItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "QuickCapture 종료 (⌘ + Q)",
            action: #selector(quit),
            keyEquivalent: ""
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

    @objc private func resetScreenCapturePermission() {
        NSApp.activate(ignoringOtherApps: true)

        let confirmation = NSAlert()
        confirmation.alertStyle = .warning
        confirmation.messageText = "화면 캡처 권한을 초기화할까요?"
        confirmation.informativeText = "QuickCapture의 기존 화면 및 시스템 오디오 녹음 권한 기록을 지웁니다. 앱을 다시 실행한 뒤 캡처를 한 번 실행하면 권한을 새로 요청합니다."
        confirmation.addButton(withTitle: "권한 초기화")
        confirmation.addButton(withTitle: "취소")

        guard confirmation.runModal() == .alertFirstButtonReturn else {
            return
        }

        CaptureRunner.resetScreenCapturePermission { [weak self] result in
            self?.showPermissionResetResult(result)
        }
    }

    private func showPermissionResetResult(_ result: Result<Void, Error>) {
        NSApp.activate(ignoringOtherApps: true)

        let alert = NSAlert()

        switch result {
        case .success:
            alert.messageText = "권한 초기화 완료"
            alert.informativeText = "QuickCapture를 종료하고 다시 실행한 뒤 캡처를 한 번 실행하세요. macOS가 요청하면 화면 및 시스템 오디오 녹음 권한을 허용하고 앱을 다시 실행하세요."
            alert.addButton(withTitle: "QuickCapture 종료")
            alert.addButton(withTitle: "나중에")

            if alert.runModal() == .alertFirstButtonReturn {
                NSApp.terminate(nil)
            }
        case .failure(let error):
            alert.alertStyle = .critical
            alert.messageText = "권한을 초기화하지 못했습니다"
            alert.informativeText = error.localizedDescription
            alert.addButton(withTitle: "확인")
            alert.runModal()
        }
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
            return "QuickCapture: \(selectedMode.title)\n단축키: option + X"
        }

        return "QuickCapture: \(selectedMode.title)\n단축키: 사용 안 함"
    }
}
