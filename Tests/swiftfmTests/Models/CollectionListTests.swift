//
//  CollectionPageTests.swift
//
//
//  Created by Daniel on 10/10/23.
//

import XCTest
import swiftfm

class CollectionListTests: XCTestCase {

    func testSucessfulDecoding() throws {
        let items = [2, 4, 6, 8, 10]
        var itemsData = try JSONEncoder().encode(items)
        var itemsString = String(data: itemsData, encoding: .utf8)!
        let intData = CollectionListTestUtils.generateJSON(items: itemsString).data(using: .utf8)!

        let intCollectionPage = try JSONDecoder().decode(CollectionList<Int>.self, from: intData)
        XCTAssertEqual(intCollectionPage.items.count, 5)
        XCTAssertEqual(intCollectionPage.items, items)

        let stringItems = ["This", "Is", "A", "Test"]
        itemsData = try JSONEncoder().encode(stringItems)
        itemsString = String(data: itemsData, encoding: .utf8)!
        let stringData = CollectionListTestUtils.generateJSON(items: itemsString).data(using: .utf8)!

        let stringCollectionPage = try JSONDecoder().decode(CollectionList<String>.self, from: stringData)
        XCTAssertEqual(stringCollectionPage.items.count, 4)
        XCTAssertEqual(stringCollectionPage.items, stringItems)
    }

    func testUnsuccessfulDecodingDueMissingRootKey() throws {
        let data = "{}".data(using: .utf8)!

        XCTAssertThrowsError(
            try JSONDecoder().decode(CollectionList<Int>.self, from: data),
            "A RuntimeError with \"Error at getting root key.\" should have been thrown") { error in
                XCTAssert(error is RuntimeError)
                XCTAssertEqual((error as! RuntimeError).errorDescription, "Error at getting root key.")
            }
    }
}
