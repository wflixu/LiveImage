# LiveImage

LiveImage 是一个用于 SwiftUI 的高性能动图显示库，支持 GIF、APNG 和 WebP 格式。适用于 macOS 15+ 和 iOS 18+，基于 Swift 6 开发。该仓库还包含一个用于演示和测试的示例应用 [LiveImageDemo](#liveimagedemo)。

## 特性

- 支持 GIF、APNG、WebP 动图格式
- 原生 SwiftUI 组件，易于集成
- 高性能解码与渲染
- 支持 macOS 15+ 和 iOS 18+
- 现代 Swift 6 语法与最佳实践

## 安装

### Swift Package Manager

在 `Package.swift` 的 dependencies 添加：

```swift
.package(url: "https://github.com/wflixu/LiveImage.git", from: "1.0.0")
```

或在 Xcode 中通过 `File > Add Packages...` 搜索 `LiveImage` 并添加。

## 快速开始

```swift
import LiveImage
import SwiftUI

struct ContentView: View {
    var body: some View {
        LiveImage(url: URL(string: "https://example.com/image.gif")!)
            .frame(width: 200, height: 200)
    }
}
```

## 支持平台

- macOS 15 及以上
- iOS 18 及以上
- Swift 6.0 及以上

## LiveImageDemo

本仓库包含 `LiveImageDemo` 示例项目，方便测试和演示 LiveImage 的功能。你可以直接运行该项目体验库的实际效果。

## 贡献

欢迎 issue 和 PR！请遵循 [贡献指南](CONTRIBUTING.md)（如有）。

## 开发与测试

- 当前开发环境：macOS 15.5，Swift 6.1.2
- 推荐使用 Xcode 15.4 及以上版本

## License

MIT License. 详见 [LICENSE](LICENSE) 文件。

