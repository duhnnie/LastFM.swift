import Foundation

public struct ArtistCorrection: Decodable {

    public let name: String
    public let mbid: String?
    public let url: URL

    private enum CodingKeys: String, CodingKey {
        case artist
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKeys.self)

        guard
            let correctionsKey = container.allKeys.first,
            let correctionsContainer = try? container.nestedContainer(
                keyedBy: StringCodingKeys.self,
                forKey: correctionsKey
            ),
            let correctionKey = correctionsContainer.allKeys.first,
            let correctionContainer = try? correctionsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: correctionKey),
            let artist = try? correctionContainer.decode(LastFMOptionalMBEntity.self, forKey: .artist)
        else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Incorrect format."
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.name = artist.name
        self.url = artist.url
        self.mbid = artist.mbid
    }

}
