import Foundation

public enum Streamable: Decodable {

    case fulltrack
    case streamable
    case streamableFullTrack
    case noStreamable

    private enum CodingKeys: String, CodingKey {
        case fulltrack
        case text = "#text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fulltrackBool = try container.decode(Bool.self, forKey: .fulltrack)
        let textBool = try container.decode(Bool.self, forKey: .text)

        if fulltrackBool && textBool {
            self = .streamableFullTrack
        } else if fulltrackBool {
            self = .fulltrack
        } else if textBool {
            self = .streamable
        } else {
            self = .noStreamable
        }
    }

}
