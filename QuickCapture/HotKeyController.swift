import Carbon.HIToolbox
import Foundation

final class HotKeyController {
    private static let hotKeyID = UInt32(1)
    private static let signature = fourCharacterCode("QCAP")

    private var eventHandlerRef: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    private let action: () -> Void
    private(set) var isEnabled: Bool

    init(isEnabled: Bool, action: @escaping () -> Void) {
        self.isEnabled = isEnabled
        self.action = action

        if isEnabled {
            register()
        }
    }

    deinit {
        unregister()
    }

    func setEnabled(_ isEnabled: Bool) {
        guard self.isEnabled != isEnabled else {
            return
        }

        self.isEnabled = isEnabled

        if isEnabled {
            register()
        } else {
            unregister()
        }
    }

    private func register() {
        guard eventHandlerRef == nil, hotKeyRef == nil else {
            return
        }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        let userData = Unmanaged.passUnretained(self).toOpaque()
        let installStatus = InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData in
                guard let event, let userData else {
                    return noErr
                }

                var receivedHotKeyID = EventHotKeyID()
                let parameterStatus = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &receivedHotKeyID
                )

                guard
                    parameterStatus == noErr,
                    receivedHotKeyID.signature == HotKeyController.signature,
                    receivedHotKeyID.id == HotKeyController.hotKeyID
                else {
                    return noErr
                }

                let controller = Unmanaged<HotKeyController>
                    .fromOpaque(userData)
                    .takeUnretainedValue()

                DispatchQueue.main.async {
                    controller.action()
                }

                return noErr
            },
            1,
            &eventType,
            userData,
            &eventHandlerRef
        )

        guard installStatus == noErr else {
            NSLog("QuickCapture failed to install hotkey handler: \(installStatus)")
            return
        }

        let hotKeyID = EventHotKeyID(
            signature: Self.signature,
            id: Self.hotKeyID
        )

        let modifiers = UInt32(optionKey)
        let registerStatus = RegisterEventHotKey(
            UInt32(kVK_ANSI_X),
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if registerStatus != noErr {
            NSLog("QuickCapture에서 option + X 단축키를 등록하지 못했습니다: \(registerStatus)")
        }
    }

    private func unregister() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }

        if let eventHandlerRef {
            RemoveEventHandler(eventHandlerRef)
            self.eventHandlerRef = nil
        }
    }

    private static func fourCharacterCode(_ string: String) -> OSType {
        var result: OSType = 0

        for character in string.utf8 {
            result = (result << 8) + OSType(character)
        }

        return result
    }
}
