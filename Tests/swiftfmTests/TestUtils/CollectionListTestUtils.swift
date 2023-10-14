//
//  File.swift
//  
//
//  Created by Daniel on 13/10/23.
//

import Foundation

internal struct CollectionListTestUtils {
    internal static func generateJSON(
        items: String,
        attrs: [String: StringTransform] = [:]
    ) -> String {
        var attrArray = [String]()

        for (key, value) in attrs {
            attrArray.append("\"\(key)\": \"\(value)\"")
        }

        return """
{
  "listname": {
    "track": \(items),
    "@attr": {
      \(attrArray.joined(separator: ", "))
    }
  }
}
"""
    }
}
