import Foundation

public struct TrackCorrection: Decodable {

    public let name: String
    public let mbid: String?
    public let url: URL
    public let artist: LastFMOptionalMBEntity
    public let artistCorrected: Bool
    public let trackCorrected: Bool

    private enum CorrectionKeys: String, CodingKey {
        case track
        case attr = "@attr"

        enum TrackKeys: String, CodingKey {
            case name
            case mbid
            case url
            case artist
        }

        enum AttrKeys: String, CodingKey {
            case artistCorrected = "artistcorrected"
            case trackCorrected = "trackcorrected"
        }
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
            let correctionContainer = try? correctionsContainer.nestedContainer(
                keyedBy: CorrectionKeys.self,
                forKey: correctionKey
            )
        else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Incorrect format."
            )

            throw DecodingError.dataCorrupted(context)
        }

        let trackContainer = try correctionContainer.nestedContainer(
            keyedBy: CorrectionKeys.TrackKeys.self,
            forKey: .track
        )

        let attrContainer = try correctionContainer.nestedContainer(
            keyedBy: CorrectionKeys.AttrKeys.self,
            forKey: .attr
        )

        self.name = try trackContainer.decode(String.self, forKey: .name)
        self.url = try trackContainer.decode(URL.self, forKey: .url)
        self.mbid = try trackContainer.decodeIfPresent(String.self, forKey: .mbid)
        self.artist = try trackContainer.decode(LastFMOptionalMBEntity.self, forKey: .artist)

        self.artistCorrected = try attrContainer.decode(Bool.self, forKey: .artistCorrected)
        self.trackCorrected = try attrContainer.decode(Bool.self, forKey: .trackCorrected)

    }

}
