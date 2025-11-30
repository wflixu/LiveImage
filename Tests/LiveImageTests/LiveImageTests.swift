import Testing
@testable import LiveImage
import Foundation

@Test func testGifImageDecoding() async throws {
    // Test GIF image creation and basic functionality
    let testData = Data([0x47, 0x49, 0x46, 0x38, 0x39, 0x61]) // Minimal GIF header
    let gifImage = GifImage(name: "test", data: testData)

    #expect(gifImage.name == "test")
    #expect(gifImage.makeImageCount() >= 0)
    #expect(gifImage.makeDelayTime(at: 0) >= 0)
}

@Test func testAnimatedImageProtocol() async throws {
    // Test that our implementations conform to AnimatedImage protocol
    let testData = Data([0x47, 0x49, 0x46, 0x38, 0x39, 0x61]) // Minimal GIF header
    let gifImage: AnimatedImage = GifImage(name: "test", data: testData)

    #expect(gifImage.name == "test")
    #expect(gifImage.makeImageCount() >= 0)
}
