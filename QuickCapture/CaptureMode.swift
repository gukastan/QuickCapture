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
            return "영역 → 파일"
        case .areaToClipboard:
            return "영역 → 클립보드"
        case .windowToClipboard:
            return "창 → 클립보드"
        case .fullScreenToClipboard:
            return "전체 화면 → 클립보드"
        }
    }

    var menuTitle: String {
        switch self {
        case .areaToFile:
            return "영역 캡처 → 파일 저장"
        case .areaToClipboard:
            return "영역 캡처 → 클립보드 복사"
        case .windowToClipboard:
            return "창 캡처 → 클립보드 복사"
        case .fullScreenToClipboard:
            return "전체 화면 캡처 → 클립보드 복사"
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
