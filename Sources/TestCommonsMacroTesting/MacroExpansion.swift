import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

/// An expected macro diagnostic.
public typealias DiagnosticSpec = SwiftSyntaxMacrosGenericTestSupport.DiagnosticSpec
/// An expected diagnostic fix-it.
public typealias FixItSpec = SwiftSyntaxMacrosGenericTestSupport.FixItSpec
/// An expected diagnostic note.
public typealias NoteSpec = SwiftSyntaxMacrosGenericTestSupport.NoteSpec

private struct MacroExpansionFailure: Error, CustomStringConvertible {
    let message: String

    var description: String { message }
}

/// Checks expansion and diagnostics using Swift Testing issues at the original failure location.
///
/// Pass through source-location defaults when wrapping this assertion in another helper.
/// - Parameters:
///   - originalSource: The source containing macro invocations.
///   - expectedExpandedSource: The expected expanded source.
///   - diagnostics: Expected diagnostics.
///   - macros: Macro names and implementation types.
///   - applyFixIts: Fix-it messages to apply.
///   - expectedFixedSource: Expected source after applying fix-its.
///   - testModuleName: The simulated module name.
///   - testFileName: The simulated source filename.
///   - indentationWidth: The indentation used in expanded source.
///   - fileID: The calling test's file identifier.
///   - filePath: The calling test's source path.
///   - line: The calling test's line.
///   - column: The calling test's column.
public func assertMacroExpansion(
    _ originalSource: String,
    expandedSource expectedExpandedSource: String,
    diagnostics: [DiagnosticSpec] = [],
    macros: [String: Macro.Type],
    applyFixIts: [String]? = nil,
    fixedSource expectedFixedSource: String? = nil,
    testModuleName: String = "TestModule",
    testFileName: String = "test.swift",
    indentationWidth: Trivia = .spaces(4),
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    let specs = macros.mapValues { MacroSpec(type: $0) }

    SwiftSyntaxMacrosGenericTestSupport.assertMacroExpansion(
        originalSource,
        expandedSource: expectedExpandedSource,
        diagnostics: diagnostics,
        macroSpecs: specs,
        applyFixIts: applyFixIts,
        fixedSource: expectedFixedSource,
        testModuleName: testModuleName,
        testFileName: testFileName,
        indentationWidth: indentationWidth,
        failureHandler: { failure in
            let location = SourceLocation(
                fileID: failure.location.fileID,
                filePath: failure.location.filePath,
                line: failure.location.line,
                column: failure.location.column
            )
            Issue.record(MacroExpansionFailure(message: failure.message), sourceLocation: location)
        },
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
    )
}
