import AppKit
import SwiftUI

open class CGImageView: NSView {
    public var contents: CGImage? = nil {
        didSet {
            layer?.setNeedsDisplay()
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }

    // 主构造器（最常用）
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    // 可选：便捷初始化器（默认大小）
    convenience init() {
        self.init(frame: .zero)
    }

    override open func display() {
        layer?.contents = contents
    }
}
