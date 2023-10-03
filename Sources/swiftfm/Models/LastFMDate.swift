//import Foundation
//
//struct LastFMDate: Decodable {
//    let uts: Int
//    let text: String
//
//    enum CodingKeys: String, CodingKey {
//        case uts = "uts"
//        case text = "#text"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let utsString = try container.decode(String.self, forKey: .uts)
//
//        uts = Int(utsString)!
//        text = try container.decode(String.self, forKey: .text)
//    }
//
//    func getDate() -> Date {
//        return Date(timeIntervalSince1970: Double(self.uts))
//    }
//}
