//
//  GIFDemoView.swift
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
        VStack {
            HStack {
                Text("Demo LiveImage APNG")
            }
            if let imageUrl = imageUrl {
                // 通过路径显示
                Text(imageUrl.path)
            }
            if let aimage = image {
                AnimatedImagePlayer(image: aimage)
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                        .clipped()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    public func loadImage() {
        guard let imageUrl = Bundle.module.url(
            forResource: "elephant",
            withExtension: "png",
            subdirectory: "Images"
        ) else {
            print("Image not found")
            return
        }
        let data = try! Data(contentsOf: imageUrl)
        self.image = APNGImage(name: "apngdemo", data: data)
        print(imageUrl.path)
        self.imageUrl = imageUrl
    }
}
