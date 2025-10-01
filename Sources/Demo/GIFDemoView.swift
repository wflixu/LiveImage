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
        VStack {
            HStack {
                Text("Demo LiveImage GIF")
            }
            if let imageUrl = imageUrl {
                // 通过路径显示
                Text(imageUrl.path)
            }
            if let aimage = image {
                LiveImageView(image: aimage)
            }
        }
        .onAppear {
            loadImage()
            
        }
    }

    public func loadImage() {
        guard let imageUrl = Bundle.module.url(
            forResource: "1342-splash",
            withExtension: "gif",
            subdirectory: "Images"
        ) else {
            print("Image not found")
            return
        }
        let data = try! Data(contentsOf: imageUrl)
        self.image = GifImage(name: "animation", data: data)
        print(imageUrl.path)
        self.imageUrl = imageUrl
    }
}
