# Tasks: Swift 6.2 APNG/GIF/WebP Animation Package

**Input**: Design documents from `/specs/001-swift-6-2/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **SwiftUI Project**: Sources/LiveImage/, Tests/LiveImageTests/ at repository root
- **Example App**: Sources/Demo/ for LiveImageDemo application
- **Platform specific**: Code must support iOS 18+ and macOS 15+ with conditional compilation as needed
- Paths shown below assume Swift project structure - adjust based on plan.md structure

## Phase 3.1: Setup
- [ ] T001 Create project structure per implementation plan with LiveImage module directories
- [ ] T002 Initialize Swift package with SwiftUI, Foundation, CoreGraphics, AVFoundation, Image I/O frameworks, CADisplayLink dependencies
- [ ] T003 [P] Configure SwiftLint for code formatting and consistency

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation. Following LiveImage Constitution testing standards: Unit tests must achieve minimum 85% code coverage, integration tests verify component interactions, and performance tests validate all image operations.**
- [ ] T004 [P] Unit tests for AnimatedImage model in Tests/LiveImageTests/Unit/ModelTests.swift (minimum 85% coverage)
- [ ] T005 [P] Unit tests for SwiftUI view components in Tests/LiveImageTests/Unit/ViewTests.swift 
- [ ] T006 [P] Integration tests for image rendering pipeline in Tests/LiveImageTests/Integration/AnimationTests.swift
- [ ] T007 [P] Performance tests for image operations in Tests/LiveImageTests/Performance/PerformanceTests.swift
- [ ] T008 [P] Accessibility tests for UI components in Tests/LiveImageTests/Accessibility/AccessibilityTests.swift
- [ ] T009 [P] Contract test for AnimatedImage View API in Tests/LiveImageTests/Contract/AnimatedImageViewTest.swift
- [ ] T010 [P] Contract test for APNGGenerator API in Tests/LiveImageTests/Contract/APNGGeneratorTest.swift
- [ ] T011 [P] Integration test for APNG display in Tests/LiveImageTests/Integration/RenderingTests.swift
- [ ] T012 [P] Memory usage test for animation in Tests/LiveImageTests/Performance/MemoryTests.swift

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T013 [P] AnimatedImage model in Sources/LiveImage/Models/AnimatedImage.swift
- [ ] T014 [P] AnimationFrame model in Sources/LiveImage/Models/AnimationFrame.swift
- [ ] T015 [P] ImageSequence model in Sources/LiveImage/Models/ImageSequence.swift
- [ ] T016 [P] APNGGenerator model in Sources/LiveImage/Models/APNGGenerator.swift
- [ ] T017 [P] AnimationViewConfiguration model in Sources/LiveImage/Models/AnimationViewConfiguration.swift
- [ ] T018 [P] ImageDecoder service in Sources/LiveImage/Services/ImageDecoder.swift
- [ ] T019 [P] ImageEncoder service in Sources/LiveImage/Services/ImageEncoder.swift
- [ ] T020 [P] AnimationManager service in Sources/LiveImage/Services/AnimationManager.swift
- [ ] T021 [P] ImageUtils in Sources/LiveImage/Utils/ImageUtils.swift
- [ ] T022 [P] ConcurrencyUtils in Sources/LiveImage/Utils/ConcurrencyUtils.swift
- [ ] T023 [P] DisplayLinkManager for AsyncStream + CADisplayLink optimization in Sources/LiveImage/Utils/DisplayLinkManager.swift
- [ ] T024 [P] AnimatedImageView SwiftUI View in Sources/LiveImage/Views/AnimatedImageView.swift
- [ ] T025 [P] APNGView SwiftUI View in Sources/LiveImage/Views/APNGView.swift

## Phase 3.4: Integration
- [ ] T026 Connect AnimationManager to DisplayLinkManager for optimized display
- [ ] T027 Integrate image decoding with animation playback
- [ ] T028 Connect APNGGenerator to ImageEncoder for APNG creation
- [ ] T029 Implement accessibility support in animated views
- [ ] T030 Performance optimization with memory management for large animations

## Phase 3.5: Polish
- [ ] T031 [P] Unit tests for validation in Tests/LiveImageTests/Unit/ServiceTests.swift
- [ ] T032 Update documentation/API reference in Sources/LiveImage/README.md
- [ ] T033 [P] Final performance benchmarks and validation
- [ ] T034 Run manual-testing.md with example app
- [ ] T035 Code review and final cleanup

## Dependencies
- Tests (T004-T012) before implementation (T013-T025)
- T013, T014 block T018, T020 (decoders and managers need models)
- T018, T019, T020 block T026-T028 (services needed for integration)
- Implementation before polish (T031-T035)

## Parallel Example
```
# Launch T004-T012 together (different test files):
Task: "Unit tests for AnimatedImage model in Tests/LiveImageTests/Unit/ModelTests.swift (minimum 85% coverage)"
Task: "Unit tests for SwiftUI view components in Tests/LiveImageTests/Unit/ViewTests.swift"
Task: "Integration tests for image rendering pipeline in Tests/LiveImageTests/Integration/AnimationTests.swift"
Task: "Performance tests for image operations in Tests/LiveImageTests/Performance/PerformanceTests.swift"
Task: "Accessibility tests for UI components in Tests/LiveImageTests/Accessibility/AccessibilityTests.swift"
Task: "Contract test for AnimatedImage View API in Tests/LiveImageTests/Contract/AnimatedImageViewTest.swift"
Task: "Contract test for APNGGenerator API in Tests/LiveImageTests/Contract/APNGGeneratorTest.swift"
Task: "Integration test for APNG display in Tests/LiveImageTests/Integration/RenderingTests.swift"
Task: "Memory usage test for animation in Tests/LiveImageTests/Performance/MemoryTests.swift"
```

## Notes
- [P] tasks = different files, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same file conflicts

## Task Generation Rules
*Applied during main() execution*

1. **From Contracts**:
   - Each contract file → contract test task [P]
   - Each endpoint → implementation task
   
2. **From Data Model**:
   - Each entity → model creation task [P]
   - Relationships → service layer tasks
   
3. **From User Stories**:
   - Each story → integration test [P]
   - Quickstart scenarios → validation tasks

4. **Ordering**:
   - Setup → Tests → Models → Services → Endpoints → Polish
   - Dependencies block parallel execution

5. **LiveImage-Specific Rules**:
   - Each image format (GIF, APNG, WebP) → decoding implementation task
   - Each platform (iOS, macOS) → compatibility validation task
   - Each UI component → accessibility implementation task [P]
   - Each performance-critical operation → benchmark task [P]

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task
- [ ] Tests achieve minimum 85% code coverage requirement per LiveImage Constitution
- [ ] Performance requirements are validated with benchmarks
- [ ] Accessibility requirements are tested for UI components
- [ ] Cross-platform compatibility tasks included for iOS/macOS