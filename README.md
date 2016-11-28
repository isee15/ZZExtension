# ZZExtension
[Xcode Source Editor Extension](https://developer.apple.com/videos/play/wwdc2016/414/)
`Xcode 8` Comment Shortcut Disabled sometimes.
Solution is 'sudo /usr/libexec/xpccachectl' and reboot
It's boring. So I write the extension

# Swift 3.0
[![Language](https://img.shields.io/badge/language-Swift%203.0-orange.svg)](https://swift.org/)

# Features
- [x] Comment Selections
- [x] Format Json
- [x] Encode/Decode(URL,Json,Timestamp,Base64,QRCode)

# Build
0. Install `Xcode 8`
1. `sudo /usr/libexec/xpccachectl`
2. Sign every targets (app & extensions) using your developer certificate
3. Build to get ZZExtension.app
4. Copy ZZExtension.app to Application
5. 系统偏好设置-》扩展-》Xcode Source Editor设置
![image](./install.png)
6. Open `Editor` menu to find extensions

## Comment Selections
![image](./snap.png)

## Encode/Decode Toolset
![image](./snap2.png)

# Reference
https://github.com/cyanzhong/xTextHandler/

