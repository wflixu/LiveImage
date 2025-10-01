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
                driver.start()
            }
        }
        .onDisappear {
            driver.stop()
        }
    }

    private func updateFrame(currentTime: TimeInterval) {
        let index = imageProvider?.index(for: currentTime)
        if let index, currentFrameIndex != index {
            if let platformImage = imageProvider?.makeImage(at: index) {
                currentFrameIndex = index
                currentImage = platformImage
            }
        }
    }
}

@MainActor
final class DisplayLinkDriver: ObservableObject {
    @Published var timestamp: TimeInterval = 0

    private var updateLink: CADisplayLink?

    init() {
        setupDisplayLink()
    }

    deinit {
        stop()
    }

    private func setupDisplayLink() {
        if let mscreen = NSScreen.main {
            updateLink = mscreen.displayLink(target: self, selector: #selector(step))
        } else {
            print("No main screen available for display link.")
        }
        if let updateLink = updateLink {
            updateLink.add(to: .current, forMode: .default)
            updateLink.isPaused = false
        } else {
            print("Failed to create display link.")
        }
    }

    @objc public func step(_ displaylink: CADisplayLink) {
        print(" step     ----------")
        MainActor.run {
            self.timestamp = displaylink.targetTimestamp
        }
    }

    public func start() {
        print("----------")
        guard let updateLink = updateLink else { return }
        updateLink.isPaused = false
    }

    func stop() {
        guard let updateLink = updateLink else { return }
        updateLink.isPaused = true
        updateLink.invalidate()
        self.updateLink = nil
    }
}
