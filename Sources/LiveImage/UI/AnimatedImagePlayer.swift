import SwiftUI

public struct AnimatedImagePlayer: NSViewRepresentable {
    let image: any AnimatedImage
    let contentMode: ContentMode

    public init(image: any AnimatedImage, contentMode: ContentMode = .fit) {
        self.image = image
        self.contentMode = contentMode
    }

    public func makeNSView(context _: Context) -> AnimatedImageView {
        return AnimatedImageView()
    }

    public func updateNSView(_ uiView: AnimatedImageView, context: Context) {
        uiView.configuration = context.environment.animatedImageViewConfiguration
        uiView.image = image
        uiView.startAnimating()
    }

    public static func dismantleUIView(_ uiView: AnimatedImageView, coordinator _: ()) {
        uiView.stopAnimating()
        uiView.image = nil
    }
}

private struct AnimatedImageConfigurationKey: EnvironmentKey {
    static let defaultValue: AnimatedImageViewConfiguration = .default
}

public extension EnvironmentValues {
    @MainActor
    var animatedImageViewConfiguration: AnimatedImageViewConfiguration {
        get { self[AnimatedImageConfigurationKey.self] }
        set { self[AnimatedImageConfigurationKey.self] = newValue }
    }
}
