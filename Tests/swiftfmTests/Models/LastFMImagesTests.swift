//
//  LastFMImagesTests.swift
//  
//
//  Created by Daniel on 10/10/23.
//

import XCTest
@testable import swiftfm

class LastFMImagesTests: XCTestCase {

    private static let defaultValues: [String: String] = [
        "small": "https://images.net/small.jpg",
        "medium": "https://images.net/medium.jpg",
        "large": "https://images.net/large.jpg",
        "extraLarge": "https://images.net/extralarge.jpg"
    ]

    internal static func generateJSON(
        small: String? = defaultValues["small"],
        medium: String? = defaultValues["medium"],
        large: String? = defaultValues["large"],
        extraLarge: String? = defaultValues["extraLarge"]
    ) -> String {
        let allImages = [
            "small": small,
            "medium": medium,
            "large": large,
            "extralarge": extraLarge
        ]

        let nonNilImages = allImages.filter { $0.value != nil }.map { (key: String, value: String?) in
            return "{ \"size\": \"\(key)\", \"#text\": \"\(value!)\" }"
        }

        return "[\(nonNilImages.joined(separator: ","))]"
    }

    func testSuccessfulDecodingWithImages() throws {
        let data = Self.generateJSON().data(using: .utf8)!
        let lastFMImages = try JSONDecoder().decode(LastFMImages.self, from: data)

        XCTAssertEqual(lastFMImages.small!.absoluteURL, URL(string: Self.defaultValues["small"]!)!)
        XCTAssertEqual(lastFMImages.medium!.absoluteURL, URL(string: Self.defaultValues["medium"]!)!)
        XCTAssertEqual(lastFMImages.large!.absoluteURL, URL(string: Self.defaultValues["large"]!)!)
        XCTAssertEqual(lastFMImages.extraLarge!.absoluteURL, URL(string: Self.defaultValues["extraLarge"]!)!)
        XCTAssertTrue(lastFMImages.hasImages)
    }

    func testSuccessfulDecodingWithNoImages() throws {
        let data = Self.generateJSON(
            small: nil,
            medium: nil,
            large: nil,
            extraLarge: nil
        ).data(using: .utf8)!
        let lastFMImages = try JSONDecoder().decode(LastFMImages.self, from: data)

        XCTAssertNil(lastFMImages.small)
        XCTAssertNil(lastFMImages.medium)
        XCTAssertNil(lastFMImages.large)
        XCTAssertNil(lastFMImages.extraLarge)
        XCTAssertFalse(lastFMImages.hasImages)
    }
}
