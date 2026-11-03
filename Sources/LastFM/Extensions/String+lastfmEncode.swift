//
//  File.swift
//  
//
//  Created by Daniel on 1/11/26.
//

import Foundation

extension String {
    
    private static let escapedOnce: Set<Unicode.Scalar> =
        ["%", "/", "?", "#", "'", "[", "]", "\"", "<", ">", "\\", "^", "`", "{", "|", "}", ";"]

    /// Encodes one artist/album/track name as a Last.fm URL path segment.
    ///
    /// By default (`escapeNonASCII: true`) the result is pure ASCII: non-ASCII
    /// characters such as `é` or `ñ` are percent-encoded as UTF-8 (`é` → `%C3%A9`).
    /// This keeps `URL(string:)` working on every macOS version, since before
    /// macOS 14 it returns `nil` for non-ASCII input. Last.fm treats the encoded
    /// and literal forms as the same URL.
    ///
    /// Pass `false` to get the form Last.fm displays, with non-ASCII characters
    /// left literal (`Café+Tacvba`). Use it for display or copying only, not for
    /// building a `URL`.
    func lastfmEncode(escapeNonASCII: Bool = true) -> String {
        let name = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Dot-segment protection: "." -> "%252E", ".." -> "%252E."
        if name == "." { return "%252E" }
        if name == ".." { return "%252E." }

        var out = ""
        for scalar in name.unicodeScalars {
            switch scalar {
            case " ":
                out += "+"
            case "+":
                out += "%252B"
            case _ where Self.escapedOnce.contains(scalar)
                      || scalar.value < 0x20 || scalar.value == 0x7F
                      || (escapeNonASCII && !scalar.isASCII):
                for byte in String(scalar).utf8 {
                    out += String(format: "%%%02X", byte)
                }
            default:
                out.unicodeScalars.append(scalar)
            }
        }
        return out
    }
    
}
