//
//  LiveImageView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//

import Combine
import Foundation
import SwiftUI

public struct LiveImageView: View {
    @StateObject private var driver = DisplayLinkDriver()
    @State private var currentFrameIndex = 0
    @State private var currentImage: NSImage?
    @State private var lastUpdate: TimeInterval = 0
    @State private var isPlaying: Bool = true
    @State private var liveImage: AnimatedImage
    private(set) var imageProvider: AnimatedImageViewModel?

    private var configuration: AnimatedImageViewConfiguration = .default

    public init(image: AnimatedImage) {
        liveImage = image
        imageProvider = AnimatedImageViewModel(name: image.name, configuration: configuration)
    }

    public var body: some View {
        Group {
            if let currentImage {
                Image(nsImage: currentImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear
            }
            HStack {
                Text(driver.timestamp.description)
            }
        }
        .onReceive(driver.$timestamp) { timestamp in
            guard isPlaying else {
                print("LiveImageView is not playing, skipping frame update.")
                return
            }
            updateFrame(currentTime: timestamp)
        }
        .onAppear {
            Task {
                // Update the image provider with the actual animated image
                imageProvider?.update(for: CGSize(width: 300, height: 300), image: liveImage)
                driver.start()
            }
        }
        .onDisappear {
            driver.stop()
        }
    }

    private func updateFrame(currentTime: TimeInterval) {
        let index = imageProvider?.index(for: currentTime)
        if let index {
            print("🎬 Frame index: \(index), current: \(currentFrameIndex)")
            if currentFrameIndex != index {
                if let platformImage = imageProvider?.makeImage(at: index) {
                    currentFrameIndex = index
                    currentImage = platformImage
                    print("✅ Updated frame \(index) with image: \(platformImage.size)")
                } else {
                    print("❌ Failed to get image for frame \(index)")
                }
            }
        } else {
            print("❌ No frame index available")
        }
    }
}

@MainActor
final class DisplayLinkDriver: ObservableObject {
    @Published var timestamp: TimeInterval = 0

    private var updateLink: CADisplayLink?
    private var isSetup = false

    init() {
        // Defer setup to avoid accessing self before initialization
        Task { @MainActor in
            if !isSetup {
                setupDisplayLink()
                isSetup = true
            }
        }
    }

    private func setupDisplayLink() {
        if let mscreen = NSScreen.main {
            updateLink = mscreen.displayLink(target: self, selector: #selector(step))
        } else {
            print("No main screen available for display link.")
        }
        if let updateLink = updateLink {
            updateLink.add(to: .main, forMode: .default)
            updateLink.isPaused = false
        } else {
            print("Failed to create display link.")
        }
    }

    @objc public func step(_ displaylink: CADisplayLink) {
        print(" step     ----------")
        timestamp = displaylink.targetTimestamp
    }

    public func start() {
        print("----------")
        if !isSetup {
            setupDisplayLink()
            isSetup = true
        }
        guard let updateLink = updateLink else { return }
        updateLink.isPaused = false
    }

    func stop() {
        guard let updateLink = updateLink else { return }
        updateLink.isPaused = true
        updateLink.invalidate()
        self.updateLink = nil
        isSetup = false
    }
}
