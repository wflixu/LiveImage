# Data Model: Swift 6.2 APNG/GIF/WebP Animation Package

## Entities

### AnimatedImage
**Representation**: An animated image entity with properties for format, frames, metadata, and playback settings
- **Properties**:
  - `format: ImageFormat` (APNG, GIF, WebP)
  - `frames: [AnimationFrame]` - Array of frames with timing information
  - `size: CGSize` - Dimensions of the image
  - `loopCount: Int` - Number of times to loop (0 = infinite)
  - `duration: TimeInterval` - Total duration of animation
  - `metadata: [String: Any]` - Format-specific metadata
- **Relationships**: Contains multiple AnimationFrame objects

### AnimationFrame  
**Representation**: A single frame within an animated image
- **Properties**:
  - `image: CGImage` - The image data for this frame
  - `duration: TimeInterval` - How long this frame should display
  - `disposalMethod: DisposalMethod` - How to handle frame disposal
  - `frameIndex: Int` - Position in the animation sequence

### ImageSequence
**Representation**: A collection of frames with timing information used for creating animated images
- **Properties**:
  - `frames: [AnimationFrame]` - Ordered collection of frames
  - `timingInfo: TimingConfiguration` - Playback settings
  - `format: ImageFormat` - Target format for the sequence
- **Relationships**: Composed of multiple AnimationFrame objects

### APNGGenerator
**Representation**: An API component for programmatically creating APNG images from input frames
- **Properties**:
  - `frames: [AnimationFrame]` - Frames to be encoded
  - `configuration: APNGConfiguration` - Encoding settings
  - `metadata: [String: Any]` - APNG-specific metadata
- **Relationships**: Uses AnimationFrame objects to build the final image

### AnimationViewConfiguration
**Representation**: Configuration for the SwiftUI animation view
- **Properties**:
  - `autoPlay: Bool` - Whether to start playing automatically
  - `loopMode: LoopMode` - How to handle looping (normal, reverse, bounce)
  - `contentMode: ContentMode` - How to scale the image
  - `playbackSpeed: Double` - Playback speed multiplier

### DisplayLinkManager
**Representation**: Component that manages animation timing using CADisplayLink and AsyncStream for optimal display synchronization
- **Properties**:
  - `displayLink: CADisplayLink?` - The display link object
  - `frameStream: AsyncStream<AnimationFrame>?` - Async stream of animation frames
  - `preferredFramesPerSecond: Int` - Target frame rate for animation
- **Relationships**: Works with AnimationFrame objects to deliver synchronized animation updates

## Validation Rules
- All image sizes must be within system memory constraints
- Frame durations must be positive values
- Loop counts must be non-negative (0 = infinite)
- Animation sequences must contain at least one frame
- File sizes must not exceed platform-specific limits

## State Transitions
- `Loading` → `Decoded` → `Rendering` → `Playing` → `Paused/Stopped`
- `DecodingFailed` → `Error` (recoverable with fallback)
- `MemoryPressure` → `LowMemoryMode` → `NormalMode`

## Constraints
- Maximum frame count limited by available memory
- Animation duration should not exceed 1 hour (configurable)
- All public APIs must be thread-safe as per Swift concurrency model
- All UI elements must support accessibility requirements