//
//  APNGDemoView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//

import LiveImage
import SwiftUI

struct APNGDemoView: View {
    @State var image: AnimatedImage?
    @State var imageUrl: URL?

    var body: some View {
        VStack(spacing: 20) {
            Text("Demo LiveImage APNG")
                .font(.title)
                .foregroundColor(.primary)

            if let imageUrl = imageUrl {
                Text("APNG loaded: \(imageUrl.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ZStack {
                // Background to show the frame
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 300, height: 300)

                if let aimage = image {
                    LiveImageView(image: aimage)
                        .frame(width: 300, height: 300)
                        .border(Color.orange, width: 2)
                } else {
                    Text("Loading APNG...")
                        .frame(width: 300, height: 300)
                        .border(Color.red, width: 2)
                }
            }

            Text("Orange border = APNG animation area")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            loadImage()
        }
    }

    public func loadImage() {
        print("=== Starting APNG loading ===")

        guard let imageUrl = Bundle.module.url(
            forResource: "elephant",
            withExtension: "png",
            subdirectory: "Images"
        ) else {
            print("❌ APNG image not found")
            return
        }

        do {
            let data = try Data(contentsOf: imageUrl)
            print("✅ APNG file size: \(data.count) bytes")
            print("✅ APNG file path: \(imageUrl.path)")

            let apngImage = APNGImage(name: "apngdemo", data: data)
            let imageCount = apngImage.makeImageCount()
            print("✅ APNG frame count: \(imageCount)")

            // Test first frame
            if let firstFrame = apngImage.makeImage(at: 0) {
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

            self.image = apngImage
            self.imageUrl = imageUrl

            print("✅ APNG image assigned to state")
        } catch {
            print("❌ Error loading APNG image: \(error)")
        }

        print("=== APNG loading completed ===")
    }
}
