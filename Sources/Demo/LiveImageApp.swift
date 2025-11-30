
import LiveImage // 导入你的库
import SwiftUI

@main
struct LiveImageApp: App {
    @State var imageUrl: URL?
    init() {}

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
