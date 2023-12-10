import Foundation

public struct ScrobbleList: Decodable {

    public let items: [ScrobbledTrack]
    public let accepted: UInt
    public let ignored: UInt

    enum CodingKeys: String, CodingKey {
        case scrobbles

        enum InnerCodingKeys: String, CodingKey {
            case items = "scrobble"
            case attr = "@attr"

            enum AttrKeys: String, CodingKey {
                case accepted
                case ignored
            }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let subcontainer = try container.nestedContainer(
            keyedBy: CodingKeys.InnerCodingKeys.self,
            forKey: .scrobbles
        )

        let attrContainer = try subcontainer.nestedContainer(
            keyedBy: CodingKeys.InnerCodingKeys.AttrKeys.self,
            forKey: .attr
        )

        self.accepted = try attrContainer.decode(UInt.self, forKey: .accepted)
        self.ignored = try attrContainer.decode(UInt.self, forKey: .ignored)

        if let item = try? subcontainer.decode(ScrobbledTrack.self, forKey: .items) {
            self.items = [item]
        }  else if let items = try? subcontainer.decode([ScrobbledTrack].self, forKey: .items) {
            self.items = items
        } else {
            let context = DecodingError.Context(
                codingPath: subcontainer.codingPath,
                debugDescription: "Can't decode scrobbles"
            )

            throw DecodingError.dataCorrupted(context)
        }
    }
}
