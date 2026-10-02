# TestCommonsMacroTesting

A separate Swift Testing adapter for SwiftSyntax macro expansion tests. This package
supports macOS 13 and iOS 17, independently of TestCommons core platform requirements.
The SwiftSyntax dependency range is 600..<700; consumer constraints select the version.
The local verification toolchain uses Swift 6.4. Core TestCommons consumers do not
resolve or build SwiftSyntax.

```swift
import TestCommonsMacroTesting

assertMacroExpansion(source, expandedSource: expected, macros: implementations)
```

Failures use `Issue.record` with the failure handler's source location. Forward
fileID, filePath, line, and column when wrapping the assertion. Existing diagnostic,
fix-it, and note specifications are re-exported as public typealiases.

Add the independent package to a macro test target:

```swift
.package(url: "https://github.com/maniramezan/TestCommonsMacroTesting.git", from: "0.1.0")
```

Use `.product(name: "TestCommonsMacroTesting", package: "TestCommonsMacroTesting")`
in the test target's dependencies. Run `swift build`, `swift test`, and
`swift format lint --strict --recursive Package.swift Sources Tests` to validate.
Swift 6.2 with SwiftSyntax 600.0.1 and Swift 6.4 with SwiftSyntax 604 are verified.

