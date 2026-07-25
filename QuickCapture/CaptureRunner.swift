import AppKit
import CoreGraphics
import Foundation

enum CaptureRunner {
    static func run(_ mode: CaptureMode) {
        guard CGPreflightScreenCaptureAccess() else {
            requestScreenCaptureAccess()
            return
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        process.arguments = mode.captureArguments

        do {
            try process.run()
        } catch {
            NSLog("QuickCapture failed to start screencapture: \(error.localizedDescription)")
        }
    }

    static func openScreenCaptureSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    private static func requestScreenCaptureAccess() {
        DispatchQueue.main.async {
            let granted = CGRequestScreenCaptureAccess()

            guard granted else {
                openScreenCaptureSettings()
                return
            }

            showRestartNotice()
        }
    }

    private static func showRestartNotice() {
        NSApp.activate(ignoringOtherApps: true)

        let alert = NSAlert()
        alert.messageText = "QuickCapture needs to restart"
        alert.informativeText = "Screen Recording permission was allowed. Quit and reopen QuickCapture once, then capture will work normally."
        alert.addButton(withTitle: "Quit QuickCapture")
        alert.addButton(withTitle: "Later")

        if alert.runModal() == .alertFirstButtonReturn {
            NSApp.terminate(nil)
        }
    }
}
