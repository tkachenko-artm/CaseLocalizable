import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CaseLocalizableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Verify we're dealing with an enum
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw CustomError.message("@CaseLocalizable can only be applied to enums")
        }
        
        // Check if enum has a raw value of type String
        guard let inheritanceClause = enumDecl.inheritanceClause,
              inheritanceClause.inheritedTypes.contains(where: { type in
                  type.type.as(IdentifierTypeSyntax.self)?.name.text == "String"
              }) else {
            throw CustomError.message("@CaseLocalizable can only be applied to enums with String raw value")
        }
        
        // Extract table parameter
        let tableArg = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression
        let tableValue = tableArg?.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text
        
        // Generate the localizedTitle property
        let propertyDecl = """
        var localizedTitle: LocalizedStringResource {
            LocalizedStringResource(rawValue, defaultValue: rawValue, table: \(tableValue))
        }
        """
        
        return [DeclSyntax(stringLiteral: propertyDecl)]
    }
}

enum CustomError: Error {
    case message(String)
}

@main
struct CaseLocalizablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CaseLocalizableMacro.self
    ]
}
