# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

LiveImage 是一个用于 SwiftUI 的高性能动图显示库，支持 GIF、APNG 和 WebP 格式。基于 Swift 6 开发，适用于 macOS 15+ 和 iOS 18+。

## 常用命令

### 构建和运行
```bash
# 构建整个项目
swift build

# 运行演示应用
swift run Demo

# 运行测试
swift test

# 清理构建产物
swift package clean
```

### 开发环境要求
- macOS 15+
- Swift 6.0+
- Xcode 15.4+

## 代码架构

### 核心组件结构
- **协议定义**: [`Core/Entity/AnimatedImage.swift`](Sources/LiveImage/Core/Entity/AnimatedImage.swift) - 定义动图的基本协议
- **图像解码器**:
  - [`Core/Image/GifImage.swift`](Sources/LiveImage/Core/Image/GifImage.swift) - GIF 格式支持
  - [`Core/Image/APNGImage.swift`](Sources/LiveImage/Core/Image/APNGImage.swift) - APNG 格式支持
  - [`Core/Image/WebPImage.swift`](Sources/LiveImage/Core/Image/WebPImage.swift) - WebP 格式支持
- **UI 组件**: [`UI/LiveImageView.swift`](Sources/LiveImage/UI/LiveImageView.swift) - 主要的 SwiftUI 视图组件
- **播放控制**: [`UI/AnimatedImagePlayer.swift`](Sources/LiveImage/UI/AnimatedImagePlayer.swift) - 动画播放逻辑
- **视图模型**: [`UI/AnimatedImageViewModel.swift`](Sources/LiveImage/UI/AnimatedImageViewModel.swift) - 数据管理

### 设计模式
- 使用协议导向设计，[`AnimatedImage`](Sources/LiveImage/Core/Entity/AnimatedImage.swift:4) 协议定义了统一的动图接口
- 实现类（如 [`GifImage`](Sources/LiveImage/Core/Image/GifImage.swift:5)）负责具体格式的解码
- [`LiveImageView`](Sources/LiveImage/UI/LiveImageView.swift:12) 使用 [`DisplayLinkDriver`](Sources/LiveImage/UI/LiveImageView.swift:70) 实现流畅的动画播放
- 支持缓存机制以优化性能

### 目标平台
- 主要支持 macOS 15+ (Sequoia)
- iOS 18+ 支持
- 使用 Swift 6 严格并发模型

## 项目结构

```
Sources/
├── LiveImage/           # 核心库代码
│   ├── Core/           # 核心数据结构和协议
│   │   ├── Entity/     # 基础实体定义
│   │   └── Image/      # 各格式图像解码器
│   └── UI/             # SwiftUI 视图组件
└── Demo/               # 演示应用
    └── Resources/      # 测试图像资源
```

## 开发注意事项

### Swift 6 并发
- 项目使用 Swift 6 严格并发模型
- 所有公共 API 都标记为 `Sendable`
- 注意 [`@MainActor`](Sources/LiveImage/UI/LiveImageView.swift:69) 的使用，UI 更新必须在主线程

### 性能考虑
- 动画播放使用 [`CADisplayLink`](Sources/LiveImage/UI/LiveImageView.swift:73) 确保流畅性
- 实现了图像缓存机制避免重复解码
- 注意内存管理，特别是处理大型动图时

### 测试资源
- 演示图像位于 [`Sources/Demo/Resources/Images/`](Sources/Demo/Resources/Images/)
- 包含 GIF、PNG 等测试用例

## 扩展开发

### 添加新的图像格式
1. 实现 [`AnimatedImage`](Sources/LiveImage/Core/Entity/AnimatedImage.swift:4) 协议
2. 将新实现类添加到 [`Core/Image/`](Sources/LiveImage/Core/Image/) 目录
3. 更新包的导出声明

### 自定义播放控制
- [`AnimatedImageViewConfiguration`](Sources/LiveImage/UI/AnimatedImageViewModel.swift) 可用于自定义播放行为
- 支持循环次数、播放速度等参数配置

## 相关文档
- 详细的开发规范在 [`specs/001-swift-6-2/`](specs/001-swift-6-2/) 目录
- API 使用示例可参考演示应用代码