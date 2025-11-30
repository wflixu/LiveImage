# Implementation Plan: Swift 6.2 APNG/GIF/WebP Animation Package

**Branch**: `001-swift-6-2` | **Date**: 2025-10-01 | **Spec**: [link]
**Input**: Feature specification from `/specs/001-swift-6-2/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from file system structure or context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code or `AGENTS.md` for opencode).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
A macOS 15+ Swift package that allows developers to easily display APNG, GIF, and WebP animated images using a native SwiftUI View. The package includes APIs to generate APNG images programmatically and follows Swift 6 best practices including concurrency features (actors, async/await) for optimal performance and thread safety. Implementation uses AsyncStream + CADisplayLink for optimized display performance.

## Technical Context
**Language/Version**: Swift 6.2  
**Primary Dependencies**: SwiftUI, Foundation, CoreGraphics, AVFoundation, Image I/O frameworks, CADisplayLink  
**Storage**: In-memory image buffers, temporary files for encoded images  
**Testing**: Swift Testing framework with 85%+ coverage  
**Target Platform**: macOS 15+  
**Project Type**: Swift Package  
**Performance Goals**: Smooth animation playback without dropped frames using AsyncStream + CADisplayLink, optimized memory usage  
**Constraints**: Thread-safe operation using Swift concurrency (actors, async/await), accessible UI components, using AsyncStream + CADisplayLink for optimized display  
**Scale/Scope**: Support for common animated image sizes and frame counts without memory issues

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Code Quality Standards**: All code must adhere to Swift 6 best practices with consistent formatting using SwiftLint, minimum 85% test coverage, and proper documentation for public APIs.

**Testing Standards**: Unit tests must achieve minimum 85% code coverage, integration tests verify component interactions, performance tests validate image operations, and Swift Testing framework is used.

**User Experience Consistency**: UI components provide consistent experience across macOS 15+, maintain predictable API behaviors, follow accessibility guidelines, and ensure uniform visual appearance.

**Performance Requirements**: Image operations meet performance benchmarks, memory usage is optimized, decoding speeds support smooth playback using AsyncStream + CADisplayLink optimization, and proper resource management follows Apple's best practices.

**Technical Excellence**: Embrace Swift 6 features while maintaining clarity, balance innovation with stability, maintain minimal dependencies, and evolve with platform updates.

## Project Structure

### Documentation (this feature)
```
specs/001-swift-6-2/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
```
Sources/
├── LiveImage/
│   ├── Views/
│   │   ├── AnimatedImageView.swift
│   │   └── APNGView.swift
│   ├── Models/
│   │   ├── AnimatedImage.swift
│   │   ├── ImageSequence.swift
│   │   └── APNGGenerator.swift
│   ├── Services/
│   │   ├── ImageDecoder.swift
│   │   ├── ImageEncoder.swift
│   │   └── AnimationManager.swift
│   └── Utils/
│       ├── ImageUtils.swift
│       ├── ConcurrencyUtils.swift
│       └── DisplayLinkManager.swift
\ntests/
├── LiveImageTests/
│   ├── Unit/
│   │   ├── ModelTests.swift
│   │   ├── ViewTests.swift
│   │   └── ServiceTests.swift
│   ├── Integration/
│   │   ├── AnimationTests.swift
│   │   └── RenderingTests.swift
│   ├── Performance/
│   │   ├── PerformanceTests.swift
│   │   └── MemoryTests.swift
│   └── Accessibility/
│       └── AccessibilityTests.swift

# Example usage
Sources/Demo/
└── main.swift
```

**Structure Decision**: Swift Package with LiveImage module containing Views, Models, Services, and Utils directories. Tests are organized by type (Unit, Integration, Performance, Accessibility) to meet constitution requirements. Additional DisplayLinkManager for AsyncStream + CADisplayLink optimization.

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate and dispatch research agents**:
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Generate contract tests** from contracts:
   - One test file per endpoint
   - Assert request/response schemas
   - Tests must fail (no implementation yet)

4. **Extract test scenarios** from user stories:
   - Each story → integration test scenario
   - Quickstart test = story validation steps

5. **Update agent file incrementally** (O(1) operation):
   - Run `.specify/scripts/bash/update-agent-context.sh qwen`
     **IMPORTANT**: Execute it exactly as specified above. Do not add or remove any arguments.
   - If exists: Add only NEW tech from current plan
   - Preserve manual additions between markers
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output to repository root

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, agent-specific file

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `.specify/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs (contracts, data model, quickstart)
- Each contract → contract test task [P]
- Each entity → model creation task [P] 
- Each user story → integration test task
- Implementation tasks to make tests pass

**Ordering Strategy**:
- TDD order: Tests before implementation 
- Dependency order: Models before services before UI
- Mark [P] for parallel execution (independent files)
- Follow LiveImage-Specific Rules: Each image format → decoding implementation, Each platform → compatibility validation, Each UI component → accessibility implementation

**Estimated Output**: 25-30 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., Complex memory management] | [memory constraints for large animations] | [basic approach insufficient for performance requirements] |
| [e.g., CADisplayLink integration] | [need for smooth 60fps animation] | [basic timer approaches insufficient for synchronized display] |

## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented

---
*Based on Constitution v1.0.0 - See `/memory/constitution.md`*