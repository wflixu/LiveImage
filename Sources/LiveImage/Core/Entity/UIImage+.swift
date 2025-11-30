// MARK: - PlatformImage 跨平台扩展
import SwiftUI
import CoreGraphics
import QuartzCore

extension PlatformImage {
    nonisolated func decoded(for size: CGSize, usePreparingForDisplay: Bool = true, interpolationQuality: CGInterpolationQuality) async -> PlatformImage? {
        #if os(iOS) || os(tvOS) || os(visionOS)
            let newSize = aspectFitSize(for: self.size, maxSize: size)
            if self.size.isLessThanOrEqualTo(newSize), usePreparingForDisplay {
                return await byPreparingForDisplay()
            }
            return resize(image: self, newSize: newSize, interpolationQuality: interpolationQuality)
        #elseif os(macOS)
            // macOS 下的实现可根据 NSImage 适配
            let newSize = aspectFitSize(for: self.size, maxSize: size)
            return resize(image: self, newSize: newSize, interpolationQuality: interpolationQuality)
        #endif
    }

    nonisolated func aspectFitSize(for currentSize: CGSize, maxSize: CGSize) -> CGSize {
        let aspectWidth = maxSize.width / currentSize.width
        let aspectHeight = maxSize.height / currentSize.height
        let scalingFactor = min(aspectWidth, aspectHeight)
        let transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
        return currentSize.applying(transform)
    }

    nonisolated func resize(image: PlatformImage, newSize: CGSize, interpolationQuality: CGInterpolationQuality) -> PlatformImage? {
        #if os(iOS) || os(tvOS) || os(visionOS)
            let rendererFormat = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
            return renderer.image { context in
                context.cgContext.interpolationQuality = interpolationQuality
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        #elseif os(macOS)
            // macOS 下 NSImage 的 resize 实现
            let newImage = NSImage(size: newSize)
            newImage.lockFocus()
            let ctx = NSGraphicsContext.current?.cgContext
            ctx?.interpolationQuality = interpolationQuality
            image.draw(in: CGRect(origin: .zero, size: newSize))
            newImage.unlockFocus()
            return newImage
        #endif
    }
}

extension CGSize {
    func isLessThanOrEqualTo(_ size: CGSize) -> Bool {
        width <= size.width && height <= size.height
    }
}
