import SwiftSyntax
import SwiftSyntaxMacros
import Testing
import TestCommonsMacroTesting

struct IdentityMacro: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws
        -> ExprSyntax
    {
        node.arguments.first!.expression
    }
}

@Test func expansionUsesSwiftTesting() {
    assertMacroExpansion("#identity(42)", expandedSource: "42", macros: ["identity": IdentityMacro.self])
}

@Test func mismatchesAreSwiftTestingIssues() {
    withKnownIssue("Verify the failure handler records a Swift Testing issue") {
        assertMacroExpansion("#identity(42)", expandedSource: "43", macros: ["identity": IdentityMacro.self])
    }
}
