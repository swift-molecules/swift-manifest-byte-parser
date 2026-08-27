public import Manifest
internal import ASCII
internal import Byte_Parser

extension Manifest.Parent {

    public static func scan(
        in source: borrowing Swift.String
    ) -> [Swift.UInt8]? {
        var lineBuffer: [Swift.UInt8] = []
        lineBuffer.reserveCapacity(128)
        var lineCount = 0
        for byte in source.utf8 {
            if byte == .ascii.lf {
                if let urlBytes = parse(lineBuffer[...]) {
                    return urlBytes
                }
                lineCount += 1
                if lineCount >= 30 { return nil }
                lineBuffer.removeAll(keepingCapacity: true)
            } else {
                lineBuffer.append(byte)
            }
        }
        if lineCount < 30 {
            return parse(lineBuffer[...])
        }
        return nil
    }

    @inline(__always)
    private static func parse(
        _ line: Swift.ArraySlice<Swift.UInt8>
    ) -> [Swift.UInt8]? {
        var input = Byte.Input(Swift.Array(line))

        while let first = input.first,
            first == .ascii.space || first == .ascii.tab
        {

            do throws(Input.Input.Stream.Error) {
                _ = try input.advance()
            } catch {}
        }

        do throws(Byte.Literal.Parser<Byte.Input>.Failure) {
            try (Byte.Literal.Parser<Byte.Input>("// parent:")).parse(&input)
        } catch {
            return nil
        }

        while let first = input.first,
            first == .ascii.space || first == .ascii.tab
        {

            do throws(Input.Input.Stream.Error) {
                _ = try input.advance()
            } catch {}
        }

        var urlBytes: [Swift.UInt8] = []
        urlBytes.reserveCapacity(64)
        while let first = input.first {
            if first == .ascii.space || first == .ascii.tab || first == .ascii.cr {
                break
            }
            urlBytes.append(first.underlying)

            do throws(Input.Input.Stream.Error) {
                _ = try input.advance()
            } catch {}
        }
        return urlBytes.isEmpty ? nil : urlBytes
    }
}
