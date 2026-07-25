import Foundation

enum CaptureMode: String, CaseIterable {
    case areaToFile
    case areaToClipboard
    case windowToClipboard
    case fullScreenToClipboard

    static let defaultsKey = "selectedCaptureMode"

    var title: String {
        switch self {
        case .areaToFile:
            return "Area -> File"
        case .areaToClipboard:
            return "Area -> Clipboard"
        case .windowToClipboard:
            return "Window -> Clipboard"
        case .fullScreenToClipboard:
            return "Full Screen -> Clipboard"
        }
    }

    var menuTitle: String {
        switch self {
        case .areaToFile:
            return "Area Capture -> Save File"
        case .areaToClipboard:
            return "Area Capture -> Clipboard"
        case .windowToClipboard:
            return "Window Capture -> Clipboard"
        case .fullScreenToClipboard:
            return "Full Screen -> Clipboard"
        }
    }

    var captureArguments: [String] {
        switch self {
        case .areaToFile:
            return ["-i", Self.fileURLForNewScreenshot().path]
        case .areaToClipboard:
            return ["-i", "-c"]
        case .windowToClipboard:
            return ["-i", "-W", "-c"]
        case .fullScreenToClipboard:
            return ["-c"]
        }
    }

    static func savedMode() -> CaptureMode {
        guard
            let rawValue = UserDefaults.standard.string(forKey: defaultsKey),
            let mode = CaptureMode(rawValue: rawValue)
        else {
            return .areaToClipboard
        }

        return mode
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.defaultsKey)
    }

    private static func fileURLForNewScreenshot() -> URL {
        let desktopURL = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop", isDirectory: true)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"

        let filename = "QuickCapture_\(formatter.string(from: Date())).png"
        return desktopURL.appendingPathComponent(filename)
    }
}
