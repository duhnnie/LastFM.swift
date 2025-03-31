//
//  File.swift
//  
//
//  Created by Daniel on 19/3/25.
//

import Foundation

extension URLComponents {
    
    // Returns a custom lastfm-encoded url
    var lastFMUrl: URL? {
        var urlComponents = self
        
        urlComponents.percentEncodedQuery = self.queryItems?.map({ item in
            guard let name = item.name.encodeURIComponent() else {
                return ""
            }
            
            return "\(name)=\(item.value?.encodeURIComponent() ?? "")"
        }).joined(separator: "&")
    
        return urlComponents.url
    }
    
}
