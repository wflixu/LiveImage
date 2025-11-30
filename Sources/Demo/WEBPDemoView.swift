//
//  WEBPDemoView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//

import LiveImage
import SwiftUI

struct WEBPDemoView: View {
    @State var image: AnimatedImage?
    @State var imageUrl: URL?

    var body: some View {
        VStack(spacing: 20) {
            Text("Demo LiveImage WebP")
                .font(.title)
                .foregroundColor(.primary)

            if let imageUrl = imageUrl {
                Text("WebP loaded: \(imageUrl.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ZStack {
                // Background to show the frame
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 300, height: 300)

                if let aimage = image {
                    LiveImageView(image: aimage)
                        .frame(width: 300, height: 300)
                        .border(Color.green, width: 2)
                } else {
                    Text("Loading WebP...")
                        .frame(width: 300, height: 300)
                        .border(Color.red, width: 2)
                }
            }

            Text("Green border = WebP animation area")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            loadImage()
        }
    }

    public func loadImage() {
        print("=== Starting WebP loading ===")

        guard let imageUrl = Bundle.module.url(
            forResource: "supported",
            withExtension: "webp",
            subdirectory: "Images"
        ) else {
            print("❌ WebP image not found")
            return
        }

        do {
            let data = try Data(contentsOf: imageUrl)
            print("✅ WebP file size: \(data.count) bytes")
            print("✅ WebP file path: \(imageUrl.path)")

            let webpImage = WebPImage(name: "webpdemo", data: data)
            let imageCount = webpImage.makeImageCount()
            print("✅ WebP frame count: \(imageCount)")

            // Test first frame
            if let firstFrame = webpImage.makeImage(at: 0) {
                print("✅ First frame loaded successfully: \(firstFrame.width)x\(firstFrame.height)")

                // Test if we can create NSImage from CGImage
                let nsImage = NSImage(cgImage: firstFrame, size: NSSize(width: firstFrame.width, height: firstFrame.height))
                if nsImage.isValid {
                    print("✅ NSImage created successfully")
                } else {
                    print("❌ Failed to create NSImage")
                }
            } else {
                print("❌ Failed to load first frame")
            }

            self.image = webpImage
            self.imageUrl = imageUrl

            print("✅ WebP image assigned to state")
        } catch {
            print("❌ Error loading WebP image: \(error)")
        }

        print("=== WebP loading completed ===")
    }
}