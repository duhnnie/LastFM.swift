import Foundation

public struct Wiki: Decodable {

    public let published: Date
    public let summary: String
    public let content: String

    private enum CodingKeys: String, CodingKey {
        case published
        case summary
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        let publishedString = try container.decode(String.self, forKey: .published)

        dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let published = dateFormatter.date(from: publishedString) else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Can't decode \"published\" property."
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.published = published
        self.summary = try container.decode(String.self, forKey: .summary)
        self.content = try container.decode(String.self, forKey: .content)
    }

}
