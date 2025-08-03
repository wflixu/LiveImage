

import AppKit
import CoreGraphics
import Foundation

open class AnimatedImageView: NSView {
    // 用于每帧刷新
    private var updateLink: CADisplayLink!
    private var currentIndex: Int? = nil
    /// 当前要显示的图像帧
    private(set) var frameImage: PlatformImage? {
        didSet {
            needsDisplay = true
        }
    }

    /// 缩放模式
    var contentMode: NSImageScaling = .scaleProportionallyUpOrDown

    public var image: (any AnimatedImage)? = nil {
        didSet {
            if let image {
                imageViewModel = AnimatedImageViewModel(name: image.name, configuration: configuration)
            }
        }
    }

    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        setupDisplayLink()
    }

    @available(*, unavailable)
    @MainActor public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDisplayLink() {
        // NSView.displayLink(target:selector:) 是 macOS 14 新增的
        updateLink = displayLink(target: self, selector: #selector(step))
        updateLink.add(to: .current, forMode: .default)
        updateLink.isPaused = false
    }

    @objc public func step(_ displaylink: CADisplayLink) {
        willUpdateContents(for: displaylink.targetTimestamp)
        needsDisplay = true
    }

    open func startAnimating() {
        updateLink.isPaused = false
    }

    open func stopAnimating() {
        updateLink.isPaused = true
    }

    public var configuration: AnimatedImageViewConfiguration = .default {
        didSet {
            if let image {
                imageViewModel = AnimatedImageViewModel(name: image.name, configuration: configuration)
            }
            layer?.magnificationFilter = configuration.contentsFilter
        }
    }

    override open func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let image = frameImage,
              let context = NSGraphicsContext.current?.cgContext else { return }

        context.saveGState()

        let imageRect = NSRect(origin: .zero, size: image.size)
        let destRect = imageFittingIn(rect: bounds, imageSize: image.size, scaling: contentMode)

        context.interpolationQuality = .high
        image.draw(in: destRect,
                   from: imageRect,
                   operation: .sourceOver,
                   fraction: 1.0,
                   respectFlipped: true,
                   hints: nil)

        context.restoreGState()
    }

    private func imageFittingIn(rect: CGRect, imageSize: CGSize, scaling: NSImageScaling) -> CGRect {
        switch scaling {
        case .scaleAxesIndependently:
            return rect
        case .scaleNone:
            return CGRect(origin: rect.origin, size: imageSize)
        case .scaleProportionallyUpOrDown, .scaleProportionallyDown:
            let aspectRatio = imageSize.width / imageSize.height
            var newWidth = rect.width
            var newHeight = newWidth / aspectRatio

            if newHeight > rect.height {
                newHeight = rect.height
                newWidth = newHeight * aspectRatio
            }

            let originX = rect.origin.x + (rect.width - newWidth) / 2
            let originY = rect.origin.y + (rect.height - newHeight) / 2

            return CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
        @unknown default:
            return rect
        }
    }

    private var imageViewModel: AnimatedImageViewModel? = nil {
        didSet {
            frameImage = nil
            currentIndex = nil

            if let image {
                print("imageViewModel update")
                imageViewModel?.update(for: bounds.size, image: image)
            }

            #if os(iOS) || os(tvOS) || os(visionOS)
                setNeedsDisplay()
            #elseif os(macOS)
                setNeedsDisplay(bounds)
            #endif
        }
    }

    public func willUpdateContents(for targetTimestamp: TimeInterval) {
        let index = imageViewModel?.index(for: targetTimestamp)
        if let index, currentIndex != index {
            if let platformImage = imageViewModel?.makeImage(at: index) {
                currentIndex = index
                frameImage = platformImage
            }
        }
    }
}
