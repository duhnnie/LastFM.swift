//
//  File.swift
//  
//
//  Created by Daniel on 19/3/25.
//

import Foundation

extension String {
    
    private static let uriComponentCharacterSet = CharacterSet.urlPathAllowed.subtracting(CharacterSet(["/", "+", "&", "'", "="]))

    func encodeURIComponent() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: Self.uriComponentCharacterSet)
    }

}
