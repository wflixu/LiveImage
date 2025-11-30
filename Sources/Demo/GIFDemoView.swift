//
//  GIFDemoView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//

import LiveImage
import SwiftUI

struct GIFDemoView: View {
    @State var image: AnimatedImage?
    @State var imageUrl: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Demo LiveImage GIF")
                .font(.title)
                .foregroundColor(.primary)

            if let imageUrl = imageUrl {
                // 通过路径显示
                Text("GIF loaded: \(imageUrl.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ZStack {
                // Background to show the frame
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 300, height: 300)

                if let aimage = image {
                    LiveImageView(image: aimage)
                        .frame(width: 300, height: 300)
                        .border(Color.blue, width: 2)
                } else {
                    Text("Loading GIF...")
                        .frame(width: 300, height: 300)
                        .border(Color.red, width: 2)
                }
            }

            Text("Blue border = GIF animation area")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            loadImage()
        }
    }

    public func loadImage() {
        print("=== Starting GIF loading ===")

        guard let imageUrl = Bundle.module.url(
            forResource: "1342-splash",
            withExtension: "gif",
            subdirectory: "Images"
        ) else {
            print("❌ Image not found")
            return
        }

        do {
            let data = try Data(contentsOf: imageUrl)
            print("✅ GIF file size: \(data.count) bytes")
            print("✅ GIF file path: \(imageUrl.path)")

            let gifImage = GifImage(name: "animation", data: data)
            let imageCount = gifImage.makeImageCount()
            print("✅ GIF frame count: \(imageCount)")

            // Test first frame
            if let firstFrame = gifImage.makeImage(at: 0) {
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

            self.image = gifImage
            self.imageUrl = imageUrl

            print("✅ Image assigned to state")
        } catch {
            print("❌ Error loading image: \(error)")
        }

        print("=== GIF loading completed ===")
    }
}
