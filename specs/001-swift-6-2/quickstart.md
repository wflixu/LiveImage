# Quickstart: Swift 6.2 APNG/GIF/WebP Animation Package

## Prerequisites
- macOS 15+
- Xcode 15.4+
- Swift 6.2+

## Installation
Add the package to your Xcode project using Swift Package Manager:
1. In Xcode, go to File > Add Package Dependencies
2. Enter the repository URL for the LiveImage package
3. Select the package and add it to your target

Or add to your Package.swift file:
```swift
.package(url: "https://github.com/your-username/liveimage.git", from: "1.0.0")
```

## Basic Usage

### Displaying Animated Images
```swift
import LiveImage
import SwiftUI

struct ContentView: View {
    let imageURL = URL(string: "https://example.com/animation.gif")!
    
    var body: some View {
        AnimatedImage(url: imageURL)
            .frame(width: 300, height: 300)
            .aspectRatio(contentMode: .fit)
    }
}
```

### Advanced Configuration
```swift
struct ContentView: View {
    let imageURL = URL(string: "https://example.com/animation.apng")!
    
    var body: some View {
        AnimatedImage(url: imageURL)
            .autoPlay(true)
            .loopMode(.repeat(3))  // Repeat 3 times
            .playbackSpeed(1.0)    // Normal speed
            .onAnimationStart { 
                print("Animation started")
            }
            .onAnimationComplete { 
                print("Animation completed")
            }
    }
}
```

### Generating APNG Images Programmatically
```swift
import LiveImage

// Create frames for your animation
let frames = createFrames()  // Array of CGImage or UIImage

// Generate APNG from frames
let generator = APNGGenerator()
let apngData = try await generator.createAPNG(
    from: frames, 
    frameDurations: [0.1, 0.1, 0.1],  // 100ms per frame
    repeatCount: 0  // Infinite loop
)

// Save or use the APNG data
try apngData.write(to: URL(fileURLWithPath: "output.apng"))
```

## Testing the Implementation
1. Create a SwiftUI test app that imports the LiveImage package
2. Add an animated image to verify it displays correctly
3. Test playback controls (play, pause, stop)
4. Verify memory usage remains stable during extended playback
5. Test accessibility features with VoiceOver enabled

## Expected Behavior
- Animated images should play smoothly without dropped frames
- Memory usage should remain stable during playback
- The AnimatedImage view should respect SwiftUI layout constraints
- APNG generation API should create valid APNG files that can be used elsewhere
- All UI elements should support accessibility features