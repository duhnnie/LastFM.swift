import Foundation

public struct ArtistInfo: Decodable {

    public let name: String
    public let mbid: String?
    public let url: URL
    public let images: LastFMImages
    public let streamable: Bool
    public let onTour: Bool
    public let stats: ArtistInfoStats
    public let similar: [LastFMExtendedEntity]
    public let tags: [LastFMEntity]
    public let bio: Wiki

    private enum CodingKeys: String, CodingKey {
        case artist

        enum ArtistKeys: String, CodingKey {
            case name
            case mbid
            case url
            case images = "image"
            case streamable
            case onTour = "ontour"
            case stats
            case similar
            case tags
            case bio

            enum SimilarKeys: String, CodingKey {
                case artist
            }

            enum TagsKeys: String, CodingKey {
                case tag
            }
        }

    }

    public init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: CodingKeys.self)

        let container = try outerContainer.nestedContainer(
            keyedBy: CodingKeys.ArtistKeys.self,
            forKey: .artist
        )

        let similarContainer = try container.nestedContainer(
            keyedBy: CodingKeys.ArtistKeys.SimilarKeys.self,
            forKey: .similar
        )

        let tagsContainer = try container.nestedContainer(
            keyedBy: CodingKeys.ArtistKeys.TagsKeys.self,
            forKey: .tags
        )

        self.name = try container.decode(String.self, forKey: .name)
        self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        self.url = try container.decode(URL.self, forKey: .url)
        self.images = try container.decode(LastFMImages.self, forKey: .images)
        self.streamable = try container.decode(Bool.self, forKey: .streamable)
        self.onTour = try container.decode(Bool.self, forKey: .onTour)
        self.stats = try container.decode(ArtistInfoStats.self, forKey: .stats)
        self.similar = try similarContainer.decode([LastFMExtendedEntity].self, forKey: .artist)
        self.tags = try tagsContainer.decode([LastFMEntity].self, forKey: .tag)
        self.bio = try container.decode(Wiki.self, forKey: .bio)
    }

}
