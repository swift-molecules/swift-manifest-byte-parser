# swift-manifest-byte-parser

Byte Parser integration for the Manifest domain. `Manifest.Parent.scan(in:)`
uses Byte Parser, with ASCII as byte-classification support, to find the first
nonempty `// parent:` directive in the first 30 source lines and return its
value as UTF-8 bytes.
