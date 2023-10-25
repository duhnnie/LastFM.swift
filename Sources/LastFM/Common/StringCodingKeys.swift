import Foundation

internal struct StringCodingKeys: CodingKey {

    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        return nil
    }
    
}
