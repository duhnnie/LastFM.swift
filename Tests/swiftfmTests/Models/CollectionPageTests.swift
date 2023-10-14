//
//  CollectionPageTests.swift
//  
//
//  Created by Daniel on 10/10/23.
//

import XCTest
import swiftfm

class CollectionPageTests: XCTestCase {

    func testSucessfulDecoding() throws {
        let items = [2, 4, 6, 8, 10]
        var itemsData = try JSONEncoder().encode(items)
        var itemsString = String(data: itemsData, encoding: .utf8)!
        let intData = CollectionPageTestUtils.generateJSON(
            items: itemsString,
            totalPages: "30",
            page: "1",
            perPage: "5",
            total: "20"
        )

        let intCollectionPage = try JSONDecoder().decode(CollectionPage<Int>.self, from: intData)
        XCTAssertEqual(intCollectionPage.items.count, 5)
        XCTAssertEqual(intCollectionPage.items, items)
        XCTAssertEqual(intCollectionPage.pagination.totalPages, 30)
        XCTAssertEqual(intCollectionPage.pagination.page, 1)
        XCTAssertEqual(intCollectionPage.pagination.perPage, 5)
        XCTAssertEqual(intCollectionPage.pagination.total, 20)

        let stringItems = ["This", "Is", "A", "Test"]
        itemsData = try JSONEncoder().encode(stringItems)
        itemsString = String(data: itemsData, encoding: .utf8)!
        let stringData = CollectionPageTestUtils.generateJSON(
            items: itemsString,
            totalPages: "300",
            page: "10",
            perPage: "50",
            total: "200"
        )

        let stringCollectionPage = try JSONDecoder().decode(CollectionPage<String>.self, from: stringData)
        XCTAssertEqual(stringCollectionPage.items.count, 4)
        XCTAssertEqual(stringCollectionPage.items, stringItems)
        XCTAssertEqual(stringCollectionPage.pagination.totalPages, 300)
        XCTAssertEqual(stringCollectionPage.pagination.page, 10)
        XCTAssertEqual(stringCollectionPage.pagination.perPage, 50)
        XCTAssertEqual(stringCollectionPage.pagination.total, 200)
    }

    func testUnsuccessfulDecodingPagination() throws {
        let items = [2, 4, 6, 8, 10]
        let itemsData = try JSONEncoder().encode(items)
        let itemsString = String(data: itemsData, encoding: .utf8)!
        let data = CollectionPageTestUtils.generateJSON(
            items: itemsString,
            totalPages: "This is not a valid totalPages",
            page: "This is not a a valid page",
            perPage: "This is a not valid perPage",
            total: "This is not a valid total"
        )

        XCTAssertThrowsError(
            try JSONDecoder().decode(CollectionPage<Int>.self, from: data),
            "A RuntimeError with \"Error at decoding pagination members.\" should have been thrown") { error in
            XCTAssert(error is RuntimeError)
            XCTAssertEqual((error as! RuntimeError).errorDescription, "Error at decoding pagination members.")
        }
    }

    func testUnsuccessfulDecodingDueMissingRootKey() throws {
        let data = "{}".data(using: .utf8)!

        XCTAssertThrowsError(
            try JSONDecoder().decode(CollectionPage<Int>.self, from: data),
            "A RuntimeError with \"Error at getting root key.\" should have been thrown") { error in
                XCTAssert(error is RuntimeError)
                XCTAssertEqual((error as! RuntimeError).errorDescription, "Error at getting root key.")
            }
    }
}
