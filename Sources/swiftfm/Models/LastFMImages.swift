import Foundation

public struct LastFMImages: Decodable {
    public enum LastFMImageSize: String, Decodable {
        case S = "small"
        case M = "medium"
        case L = "large"
        case XL = "extralarge"
    }

    private(set) public var small: URL?
    private(set) public var medium: URL?
    private(set) public var large: URL?
    private(set) public var extraLarge: URL?

    public var hasImages: Bool {
        return [
            small,
            medium,
            large,
            extraLarge
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
            let size = try imageContainer.decode(LastFMImageSize.self, forKey: .size)
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
            }
        }
    }
}
