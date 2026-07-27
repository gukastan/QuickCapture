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
            return "영역을 선택해 파일로 저장"
        case .areaToClipboard:
            return "영역을 선택해 클립보드에 복사"
        case .windowToClipboard:
            return "창을 선택해 클립보드에 복사"
        case .fullScreenToClipboard:
            return "전체 화면을 클립보드에 복사"
        }
    }

    var menuTitle: String {
        switch self {
        case .areaToFile:
            return "영역을 선택해 파일로 저장 (⌘ + shift + 4)"
        case .areaToClipboard:
            return "영역을 선택해 클립보드에 복사 (⌘ + shift + control + 4)"
        case .windowToClipboard:
            return "창을 선택해 클립보드에 복사 (⌘ + shift + control + 4 → space)"
        case .fullScreenToClipboard:
            return "전체 화면을 클립보드에 복사 (⌘ + shift + control + 3)"
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
