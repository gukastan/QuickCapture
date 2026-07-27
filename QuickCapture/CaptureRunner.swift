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
        alert.messageText = "QuickCapture를 다시 실행해야 합니다"
        alert.informativeText = "화면 기록 권한이 허용되었습니다. QuickCapture를 한 번 종료한 뒤 다시 실행하면 캡처 기능을 정상적으로 사용할 수 있습니다."
        alert.addButton(withTitle: "QuickCapture 종료")
        alert.addButton(withTitle: "나중에")

        if alert.runModal() == .alertFirstButtonReturn {
            NSApp.terminate(nil)
        }
    }
}
