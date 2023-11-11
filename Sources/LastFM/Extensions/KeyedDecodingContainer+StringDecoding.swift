import Foundation

fileprivate struct UIntWrapper: Decodable {

    let value: UInt

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(UInt.self) {
            self.value = value
            return
        }

        guard
            let valueString = try? container.decode(String.self),
            let value = UInt(valueString)
        else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "UInt format was not parseable.")
            throw DecodingError.dataCorrupted(context)
        }

        self.value = value
    }

}

fileprivate struct UInt8Wrapper: Decodable {

    let value: UInt8

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(UInt8.self) {
            self.value = value
            return
        }

        guard
            let valueString = try? container.decode(String.self),
            let value = UInt8(valueString)
        else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "UInt8 format was not parseable.")
            throw DecodingError.dataCorrupted(context)
        }

        self.value = value
    }

}

fileprivate struct IntWrapper: Decodable {

    let value: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Int.self) {
            self.value = value
            return
        }

        guard
            let valueString = try? container.decode(String.self),
            let value = Int(valueString)
        else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Int format was not parseable."
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.value = value
    }

}

fileprivate struct FloatWrapper: Decodable {

    let value: Float

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Float.self) {
            self.value = value
            return
        }

        guard
            let valueString = try? container.decode(String.self),
            let value = Float(valueString)
        else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Float format was not parseable."
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.value = value
    }

}

fileprivate struct BoolWrapper: Decodable {

    let value: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Bool.self) {
            self.value = value
            return
        } else if let valueInt = try? container.decode(Int.self) {
            self.value = valueInt != 0
            return
        }

        guard
            let valueString = try? container.decode(String.self)
        else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Bool format was not parseable."
            )

            throw DecodingError.dataCorrupted(context)
        }

        self.value = !["false", "0", ""].contains(valueString.lowercased())
    }

}

internal extension KeyedDecodingContainer {

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        return try self.decode(UIntWrapper.self, forKey: key).value
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        return try self.decode(UInt8Wrapper.self, forKey: key).value
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        return try self.decode(IntWrapper.self, forKey: key).value
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        return try self.decode(FloatWrapper.self, forKey: key).value
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        return try self.decode(BoolWrapper.self, forKey: key).value
    }

    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard
            (self.allKeys.contains { $0.stringValue == key.stringValue })
        else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard
            (self.allKeys.contains { $0.stringValue == key.stringValue })
        else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        guard
            (self.allKeys.contains { $0.stringValue == key.stringValue })
        else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard
            (self.allKeys.contains { $0.stringValue == key.stringValue })
        else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard
            (self.allKeys.contains { $0.stringValue == key.stringValue })
        else {
            return nil
        }

        return try decode(type, forKey: key)
    }
    
}
