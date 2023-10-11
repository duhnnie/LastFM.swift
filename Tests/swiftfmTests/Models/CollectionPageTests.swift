//
//  CollectionPageTests.swift
//  
//
//  Created by Daniel on 10/10/23.
//

import XCTest
import swiftfm

class CollectionPageTests: XCTestCase {

    private static func generateJSON<T: Codable>(
        items: [T],
        totalPages: String,
        page: String,
        perPage: String,
        total: String
    ) throws -> Data {
        let itemsStringArray = try items.map { item in
            return try JSONEncoder().encode(item)
        }.map { data in
            return String(data: data, encoding: .utf8)!
        }

        return """
{
  "listname": {
    "track": [
        \(itemsStringArray.joined(separator: ","))
    ],
    "@attr": {
      "totalPages": "\(totalPages)",
      "page": "\(page)",
      "perPage": "\(perPage)",
      "total": "\(total)"
    }
  }
}
""".data(using: .utf8)!
    }

    func testSucessfulDecoding() throws {
        let intData = try! Self.generateJSON(
            items: [2, 4, 6, 8, 10],
            totalPages: "30",
            page: "1",
            perPage: "5",
            total: "20"
        )

        let intCollectionPage = try JSONDecoder().decode(CollectionPage<Int>.self, from: intData)
        XCTAssertEqual(intCollectionPage.items.count, 5)
        XCTAssertEqual(intCollectionPage.items, [2, 4, 6, 8, 10])
        XCTAssertEqual(intCollectionPage.pagination.totalPages, 30)
        XCTAssertEqual(intCollectionPage.pagination.page, 1)
        XCTAssertEqual(intCollectionPage.pagination.perPage, 5)
        XCTAssertEqual(intCollectionPage.pagination.total, 20)

        let stringData = try! Self.generateJSON(
            items: ["This", "Is", "A", "Test"],
            totalPages: "300",
            page: "10",
            perPage: "50",
            total: "200"
        )

        let stringCollectionPage = try JSONDecoder().decode(CollectionPage<String>.self, from: stringData)
        XCTAssertEqual(stringCollectionPage.items.count, 4)
        XCTAssertEqual(stringCollectionPage.items, ["This", "Is", "A", "Test"])
        XCTAssertEqual(stringCollectionPage.pagination.totalPages, 300)
        XCTAssertEqual(stringCollectionPage.pagination.page, 10)
        XCTAssertEqual(stringCollectionPage.pagination.perPage, 50)
        XCTAssertEqual(stringCollectionPage.pagination.total, 200)
    }

    func testUnsuccessfulDecodingPagination() throws {
        let data = try! Self.generateJSON(
            items: [2, 4, 6, 8, 10],
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
