# API Contract: Animated Image Operations

## AnimatedImage View API

### Initializers
```swift
init(url: URL) 
init(data: Data)
init(uiImage: UIImage)  // iOS
init(nsImage: NSImage)  // macOS
```

### Configuration Methods
```swift
func autoPlay(_ autoPlay: Bool) -> AnimatedImage
func loopMode(_ mode: LoopMode) -> AnimatedImage  
func playbackSpeed(_ speed: Double) -> AnimatedImage
func contentMode(_ mode: ContentMode) -> AnimatedImage
```

### Event Handlers
```swift
func onAnimationStart(perform action: () -> Void) -> AnimatedImage
func onAnimationComplete(perform action: () -> Void) -> AnimatedImage
func onAnimationLoop(perform action: () -> Void) -> AnimatedImage
```

## APNGGenerator API

### Public Methods
```swift
func createAPNG(
    from frames: [CGImage], 
    frameDurations: [TimeInterval], 
    repeatCount: Int
) async throws -> Data

func createAPNG(
    from uiImages: [UIImage], 
    frameDurations: [TimeInterval], 
    repeatCount: Int
) async throws -> Data
```

## Supported Formats
- Input formats: GIF, APNG, WebP
- Output format: APNG
- Frame formats: CGImage, UIImage, NSImage

## Animation Timing Implementation
- Uses CADisplayLink synchronized with display refresh rate (up to 120Hz)
- Implements AsyncStream for async/await integration with frame delivery
- Maintains smooth animation at target frame rates

## Error Handling
- `InvalidFormatError`: When the input data is not a supported format
- `DecodingError`: When the image data cannot be decoded properly  
- `MemoryError`: When there's insufficient memory to process the image
- `EncodingError`: When APNG encoding fails

## Performance Requirements
- Frame decoding should complete within 50ms for standard sizes (100x100 to 800x800)
- Memory usage should not exceed 10MB per animated image (configurable)
- Animation should maintain 60fps when possible
- Preloading should not block the main thread

## Thread Safety
- All public APIs must be thread-safe
- Decoding operations executed on background actors
- UI updates dispatched to main actor only