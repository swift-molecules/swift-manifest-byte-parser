import Manifest
import Manifest_Byte_Parser
import Testing

extension Manifest.Parent {
    @Suite
    struct Test {
        @Suite struct Scan {}
    }
}

extension Manifest.Parent.Test.Scan {
    @Test
    func `Absent directive returns nil`() {
        let content = """
            import Linter

            let manifest = Lint.Manifest(enabledRuleIDs: [])
            """
        #expect(Manifest.Parent.scan(in: content) == nil)
    }

    @Test
    func `https URL is returned as bytes`() {
        let content = """
            // parent: https://raw.githubusercontent.com/swift-institute/.github/main/Lint.swift
            import Linter
            """
        let expected = Swift.Array(
            "https://raw.githubusercontent.com/swift-institute/.github/main/Lint.swift".utf8
        )
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `http URL is returned as bytes`() {
        let content = "// parent: http://example.com/Lint.swift\n"
        let expected = Swift.Array("http://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `file URL is returned as bytes`() {
        let content = "// parent: file:///tmp/parent.swift\n"
        let expected = Swift.Array("file:///tmp/parent.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Leading whitespace before directive is stripped`() {
        let content = "    // parent: https://example.com/Lint.swift\n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Tab-indented directive is parsed`() {
        let content = "\t// parent: https://example.com/Lint.swift\n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Unknown scheme passes through verbatim — caller validates`() {
        let content = "// parent: ftp://example.com/Lint.swift\n"
        let expected = Swift.Array("ftp://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Directive past line 30 is ignored`() {
        var lines: [Swift.String] = []
        for _ in 0..<31 {
            lines.append("// padding")
        }
        lines.append("// parent: https://example.com/Lint.swift")
        let content = lines.joined(separator: "\n")
        #expect(Manifest.Parent.scan(in: content) == nil)
    }

    @Test
    func `Directive at exactly line 30 is parsed`() {
        var lines: [Swift.String] = []
        for _ in 0..<29 {
            lines.append("// padding")
        }
        lines.append("// parent: https://example.com/Lint.swift")
        let content = lines.joined(separator: "\n")
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Trailing whitespace after URL is dropped`() {
        let content = "// parent: https://example.com/Lint.swift   \n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `First valid directive wins when multiple are present`() {
        let content = """
            // parent: https://first.example.com/Lint.swift
            // parent: https://second.example.com/Lint.swift
            """
        let expected = Swift.Array("https://first.example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }
}
