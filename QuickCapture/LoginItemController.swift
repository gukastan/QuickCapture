import Foundation
import ServiceManagement

enum LoginItemController {
    private static let defaultsKey = "launchAtLoginEnabled"

    static var isEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: defaultsKey) == nil {
                return true
            }

            return UserDefaults.standard.bool(forKey: defaultsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: defaultsKey)
            applySavedPreference()
        }
    }

    static func applySavedPreference() {
        if isEnabled {
            register()
        } else {
            unregister()
        }
    }

    private static func register() {
        guard SMAppService.mainApp.status != .enabled else {
            return
        }

        do {
            try SMAppService.mainApp.register()
        } catch {
            NSLog("QuickCapture failed to register launch at login: \(error.localizedDescription)")
        }
    }

    private static func unregister() {
        guard SMAppService.mainApp.status == .enabled else {
            return
        }

        do {
            try SMAppService.mainApp.unregister()
        } catch {
            NSLog("QuickCapture failed to unregister launch at login: \(error.localizedDescription)")
        }
    }
}
