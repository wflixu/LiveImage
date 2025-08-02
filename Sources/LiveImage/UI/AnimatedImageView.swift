
#if os(iOS) || os(tvOS) || os(visionOS)
    import CoreGraphics
    import Foundation
    import SwiftUI
#elseif os(macOS)
    import AppKit
    import CoreGraphics
    import Foundation
#endif

open class AnimatedImageView: CGImageView {
    lazy var updateLink: CADisplayLink = { preconditionFailure() }()


    public var image: (any AnimatedImage)? = nil {
        didSet {
            if let image {
                imageViewModel = AnimatedImageViewModel(name: image.name, configuration: configuration)
            }
        }
    }

    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        print("frame.")
        updateLink = displayLink(
            target: self,
            selector: #selector(step)
        )
        updateLink.add(to: .main, forMode: .common)
        updateLink.isPaused = false;
    }
    
    @MainActor public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private var imageViewModel: AnimatedImageViewModel? = nil {
        didSet {
            contents = nil
            currentIndex = nil

            if let image {
                imageViewModel?.update(for: bounds.size, image: image)
            }

            #if os(iOS) || os(tvOS) || os(visionOS)
                setNeedsDisplay()
            #elseif os(macOS)
                setNeedsDisplay(bounds)
            #endif
        }
    }

    private var currentIndex: Int? = nil

    #if os(iOS) || os(tvOS) || os(visionOS)
        override open func didMoveToSuperview() {
            super.didMoveToSuperview()
            if superview == nil {
                imageViewModel?.task?.cancel()
            }
        }

        override open func layoutSubviews() {
            super.layoutSubviews()
            if let image {
                imageViewModel?.update(for: bounds.size, image: image)
            }
        }

    #elseif os(macOS)
        // NSView 没有 didMoveToSuperview/layoutSubviews，如有需要可自定义
        func didMoveToSuperview() {
            if superview == nil {
                imageViewModel?.task?.cancel()
            }
        }

        func layoutSubviews() {
            if let image {
                imageViewModel?.update(for: bounds.size, image: image)
            }
        }
    #endif
    @objc public func step(displaylink: CADisplayLink) {
        print(displaylink.targetTimestamp)
        willUpdateContents(for: displaylink.targetTimestamp)
    }

    public func willUpdateContents(for targetTimestamp: TimeInterval) {
        
        let index = imageViewModel?.index(for: targetTimestamp)
        print("currentIndex\(currentIndex)-- \(index)")
        if let index, currentIndex != index {
            let newContents = imageViewModel?.makeImage(at: index)?.cgImage
            if let newContents {
                currentIndex = index
                contents = newContents as! CGImage
            }
        }
    }
}
