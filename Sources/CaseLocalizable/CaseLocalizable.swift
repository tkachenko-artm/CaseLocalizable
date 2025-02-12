// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(localizedTitle))
public macro CaseLocalizable(table: String? = nil) = #externalMacro(module: "CaseLocalizableMacros", type: "CaseLocalizableMacro")
