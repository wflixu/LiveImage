//
//  ContentView.swift
//  LiveImage
//
//  Created by 李旭 on 2025/8/3.
//
import LiveImage
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Demo LiveImage")
            }
            HStack {
                GIFDemoView()
            }
            HStack {
                APNGDemoView()
            }
            HStack {
                WEBPDemoView()
            }
        }
    }
}
