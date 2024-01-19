import Foundation

public struct LastFMImages: Codable {
    public enum LastFMImageSize: String, Decodable, CaseIterable {
        case S = "small"
        case M = "medium"
        case L = "large"
        case XL = "extralarge"
        case MG = "mega"
    }

    private(set) public var small: URL?
    private(set) public var medium: URL?
    private(set) public var large: URL?
    private(set) public var extraLarge: URL?
    private(set) public var mega: URL?

    public var hasImages: Bool {
        return [
            small,
            medium,
            large,
            extraLarge,
            mega
        ].contains { url in
            url != nil
        }
    }

    internal enum CodingKeys: String, CodingKey {
        case size = "size"
        case url = "#text"
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        while !container.isAtEnd {
            let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.self)

            guard
                let size = try? imageContainer.decode(LastFMImageSize.self, forKey: .size)
            else {
                continue
            }

            let urlString = try imageContainer.decode(String.self, forKey: .url)

            switch (size) {
            case .S:
                self.small = URL(string: urlString)
            case .M:
                self.medium = URL(string: urlString)
            case .L:
                self.large = URL(string: urlString)
            case .XL:
                self.extraLarge = URL(string: urlString)
            case .MG:
                self.mega = URL(string: urlString)
            }
        }
    }
    
    private func encodeItem(
        container: inout UnkeyedEncodingContainer,
        url: URL?,
        size: LastFMImageSize
    ) throws {
        if let url = url {
            var subcontainer = container.nestedContainer(keyedBy: CodingKeys.self)
            
            try subcontainer.encode(size.rawValue, forKey: .size)
            try subcontainer.encode(url, forKey: .url)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        for size in LastFMImageSize.allCases {
            switch size {
            case .S:
                try encodeItem(container: &container, url: small, size: size)
            case .M:
                try encodeItem(container: &container, url: medium, size: size)
            case .L:
                try encodeItem(container: &container, url: large, size: size)
            case .XL:
                try encodeItem(container: &container, url: extraLarge, size: size)
            case .MG:
                try encodeItem(container: &container, url: mega, size: size)
            }
        }
        
    }
}
