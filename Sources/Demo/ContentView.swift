//
//  ContentView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//
import LiveImage
import SwiftUI

struct ContentView: View {
    @State var image: AnimatedImage?
    @State var imageUrl: URL?
    @State var pngImage: NSImage?

//    init() {
    ////        // Load image data
    ////        let url = Bundle.main.url(forResource: "animation", withExtension: "gif")!
    ////        let data = try! Data(contentsOf: url)
    ////
    ////        // Create the animated image
    ////        self._image = State(initialValue: GifImage(name: "animation", data: data))
//    }
//
    var body: some View {
        VStack {
            HStack {
                Text("Demo LiveImage")
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
