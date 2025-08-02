//
//  DemoView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/2.
//

import SwiftUI

struct AnimatedGIFView: View {
    // 假设你有命名为 gif_0, gif_1, ..., gif_9 的图片资源
    private let frameCount = 10
    private let frameDuration: TimeInterval = 0.1 // 每帧 100ms

    @State private var currentFrame = 0

    var body: some View {
        HStack {
            Text("Demo LiveImage")
        }
    }
}

