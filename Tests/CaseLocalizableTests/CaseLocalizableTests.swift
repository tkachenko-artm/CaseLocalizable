import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CaseLocalizableMacros

final class CaseLocalizableTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "CaseLocalizable": CaseLocalizableMacro.self,
    ]
    
    func testMacroWithTable() {
        assertMacroExpansion(
            """
            @CaseLocalizable(table: "Sport")
            enum Sport: String {
                case football = "word_sport_football"
            }
            """,
            expandedSource: """
            enum Sport: String {
                case football = "word_sport_football"
                var localizedTitle: LocalizedStringResource {
                    LocalizedStringResource(String(describing: self.rawValue), table: "Sport")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithoutTable() {
        assertMacroExpansion(
            """
            @CaseLocalizable
            enum Sport: String {
                case football = "word_sport_football"
            }
            """,
            expandedSource: """
            enum Sport: String {
                case football = "word_sport_football"
                var localizedTitle: LocalizedStringResource {
                    LocalizedStringResource(String(describing: self.rawValue), table: nil)
                }
            }
            """,
            macros: testMacros
        )
    }
}
