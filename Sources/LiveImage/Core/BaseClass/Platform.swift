#if os(iOS) || os(tvOS) || os(watchOS)
import SwiftUI
import UIKit

public typealias PlatformViewRepresentable = UIViewRepresentable
public typealias PlatformView = UIView
public typealias PlatformImage = UIImage

#elseif os(macOS)
import AppKit
import SwiftUI

public typealias PlatformViewRepresentable = NSViewRepresentable
public typealias PlatformView = NSView
public typealias PlatformImage = NSImage

#endif
