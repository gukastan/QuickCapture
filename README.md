# QuickCapture for macOS

QuickCapture는 macOS의 기본 스크린샷 기능을 한 번의 클릭이나 단축키로 실행하는 가벼운 메뉴 막대 앱입니다.

편집기, 클라우드 동기화, 계정, 추적 기능 없이 캡처에 필요한 기능만 제공합니다. 우클릭 메뉴에서 캡처 방식을 한 번 선택한 뒤 메뉴 막대 아이콘을 좌클릭하거나 `Option + X`를 누르면 같은 기능을 바로 실행할 수 있습니다.

## 주요 기능

- macOS 메뉴 막대의 카메라 아이콘
- 좌클릭으로 현재 선택된 캡처 기능 실행
- 우클릭으로 캡처 기능 선택 및 앱 설정
- 전역 단축키 `Option + X`
- 우클릭 메뉴에서 단축키 사용 여부 설정
- 마지막으로 선택한 캡처 기능을 재부팅 후에도 기억
- 로그인 시 자동 실행 설정
- Dock 아이콘 없이 메뉴 막대에서만 실행
- 화면 기록 권한 설정 바로가기
- 별도의 캡처 엔진 대신 macOS 기본 `/usr/sbin/screencapture` 사용
- Intel Mac과 Apple Silicon Mac 모두 지원하는 Universal 앱

## 캡처 기능

- 영역 캡처 → 파일 저장
- 영역 캡처 → 클립보드 복사
- 창 캡처 → 클립보드 복사
- 전체 화면 캡처 → 클립보드 복사

최초 기본값은 `영역 캡처 → 클립보드 복사`입니다. 캡처 후 ChatGPT, Slack, 문서 등에 `Command + V`로 바로 붙여넣을 수 있습니다.

## 사용 방법

### 좌클릭

메뉴 막대의 카메라 아이콘을 좌클릭하면 우클릭 메뉴에서 마지막으로 선택한 캡처 기능을 실행합니다.

### 우클릭

카메라 아이콘을 우클릭하면 다음 기능을 사용할 수 있습니다.

- 캡처 기능 선택
- 로그인 시 자동 실행 켜기 또는 끄기
- `Option + X` 단축키 켜기 또는 끄기
- 화면 기록 설정 열기
- QuickCapture 종료

현재 선택된 캡처 기능에는 체크 표시가 나타납니다. 선택한 기능과 단축키 설정은 앱을 종료하거나 Mac을 재부팅해도 유지됩니다.

### 단축키

앱이 실행 중일 때 `Option + X`를 누르면 현재 선택된 캡처 기능이 실행됩니다.

단축키를 끄면:

- 다른 앱에서 `Option + X`를 사용할 수 있습니다.
- 메뉴 막대 아이콘은 계속 사용할 수 있습니다.
- 좌클릭 캡처 기능도 계속 작동합니다.
- 단축키 사용 여부가 재부팅 후에도 유지됩니다.

## 요구 사항

- macOS 13 이상
- Intel Mac 또는 Apple Silicon Mac
- 소스 빌드 시 Xcode 16.4 이상 권장

## 다운로드 및 설치

1. GitHub Releases에서 최신 `QuickCapture-버전-universal.zip` 파일을 내려받습니다.
2. ZIP 파일의 압축을 풉니다.
3. `QuickCapture.app`을 `/Applications` 폴더로 옮깁니다.
4. 아래의 **확인되지 않은 개발자 차단 해결 방법**에 따라 처음 한 번 앱 실행을 승인합니다.
5. 화면 기록 권한을 허용합니다.
6. 권한을 허용한 뒤 QuickCapture를 한 번 종료하고 다시 실행합니다.

앱을 여러 폴더에서 동시에 실행하지 마세요. macOS의 화면 기록 권한은 앱 번들과 위치의 영향을 받을 수 있으므로 `/Applications/QuickCapture.app` 한 개만 사용하는 것이 좋습니다.

## 확인되지 않은 개발자 차단 해결 방법

배포 앱은 임시 서명되어 있지만 유료 Apple Developer 인증서로 공증되지는 않았습니다. 따라서 처음 실행할 때 macOS가 다음과 비슷한 경고를 표시할 수 있습니다.

```text
개발자를 확인할 수 없기 때문에 QuickCapture를 열 수 없습니다.
```

앱은 반드시 이 저장소의 공식 Releases에서 내려받은 파일인지 먼저 확인하세요. 출처를 확인한 뒤 다음 방법으로 실행을 승인할 수 있습니다.

### 방법 1: Finder에서 열기

1. Finder에서 `/Applications` 폴더를 엽니다.
2. `QuickCapture.app`을 Control-클릭하거나 우클릭합니다.
3. 메뉴에서 **열기**를 선택합니다.
4. 다시 나타나는 창에서 **열기**를 선택합니다.

### 방법 2: 시스템 설정에서 승인

1. QuickCapture를 한 번 실행해 차단 알림이 나타나게 합니다.
2. Apple 메뉴 `` → **시스템 설정**을 엽니다.
3. **개인정보 보호 및 보안**으로 이동합니다.
4. 아래쪽 **보안** 항목에서 QuickCapture에 대한 **그래도 열기**를 선택합니다.
5. 로그인 암호 또는 Touch ID로 승인합니다.

`그래도 열기` 버튼은 앱 실행이 차단된 뒤 약 1시간 동안 표시됩니다. 한 번 승인하면 이후에는 일반 앱처럼 실행할 수 있습니다.

Apple 공식 안내: [알 수 없는 개발자의 Mac 앱 열기](https://support.apple.com/ko-kr/guide/mac-help/-mh40616/mac)

## 화면 기록 권한

QuickCapture가 스크린샷을 실행하려면 macOS의 화면 기록 권한이 필요합니다.

캡처가 작동하지 않는 경우:

1. Apple 메뉴 `` → **시스템 설정**을 엽니다.
2. **개인정보 보호 및 보안**으로 이동합니다.
3. **화면 및 시스템 오디오 기록** 또는 **화면 기록**을 엽니다.
4. QuickCapture를 켭니다.
5. QuickCapture를 종료하고 다시 실행합니다.

우클릭 메뉴의 **화면 기록 설정 열기**를 사용해 해당 설정으로 바로 이동할 수도 있습니다.

권한 요청이 계속 반복되면 `/Applications/QuickCapture.app`만 남기고 Xcode 빌드나 다른 폴더의 복사본은 종료하세요. 개발 중 권한 기록이 꼬인 경우 다음 명령으로 화면 기록 권한을 초기화할 수 있습니다.

```bash
tccutil reset ScreenCapture local.quickcapture
```

초기화 후 `/Applications/QuickCapture.app`을 다시 실행하고 화면 기록 권한을 허용하세요.

## 파일 저장

`영역 캡처 → 파일 저장`은 바탕 화면에 다음과 같은 이름으로 파일을 저장합니다.

```text
QuickCapture_2026-07-27_12-34-56.png
```

클립보드 복사 기능은 캡처 이미지를 시스템 클립보드에 넣으며 `Command + V`로 붙여넣을 수 있습니다.

## 소스 빌드

1. Xcode에서 `QuickCapture.xcodeproj`를 엽니다.
2. `QuickCapture` 스킴을 선택합니다.
3. Run을 누릅니다.
4. 메뉴 막대 오른쪽에서 카메라 아이콘을 확인합니다.
5. 카메라 아이콘을 우클릭해 캡처 기능을 선택합니다.
6. 아이콘을 좌클릭하거나 `Option + X`를 눌러 선택한 기능을 실행합니다.

일상적으로 사용할 빌드는 `/Applications` 폴더로 옮겨 한 위치에서 실행하는 것이 좋습니다.

## 프로젝트 구조

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

## 동작 방식

- `StatusBarController.swift`: 메뉴 막대 아이콘, 좌클릭, 우클릭 메뉴와 도움말 관리
- `CaptureMode.swift`: 네 가지 캡처 기능과 마지막 선택값 저장
- `CaptureRunner.swift`: macOS 기본 `screencapture` 명령 실행
- `HotKeyController.swift`: 전역 `Option + X` 단축키 등록 및 해제
- `LoginItemController.swift`: 로그인 시 자동 실행 관리
- `Info.plist`: Dock 아이콘 없이 메뉴 막대 앱으로 실행되도록 설정

## 라이선스

MIT License입니다. 자유롭게 사용, 수정, 포크 및 재배포할 수 있습니다.
