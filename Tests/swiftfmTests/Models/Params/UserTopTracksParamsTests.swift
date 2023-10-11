//
//  UserTopTracksParamsTests.swift
//  
//
//  Created by Daniel on 11/10/23.
//

import XCTest
@testable import swiftfm

class UserTopTracksParamsTests: XCTestCase {

    func testInitWithDefaultValues() throws {
        let user = "SomeUser"
        let instance = UserTopTracksParams(user: user)

        XCTAssertEqual(instance.user, user)
        XCTAssertEqual(instance.page, 1)
        XCTAssertEqual(instance.limit, 50)
        XCTAssertEqual(instance.period, .overall)
    }

    func testInitWithCustomValues() throws {
        let user = "SomeUser2"
        let page: UInt = 34
        let limit: UInt = 20
        let period = UserTopTracksParams.Period.last7Days
        let instance = UserTopTracksParams(user: user, period: period, limit: limit, page: page)

        XCTAssertEqual(instance.user, user)
        XCTAssertEqual(instance.page, page)
        XCTAssertEqual(instance.limit, limit)
        XCTAssertEqual(instance.period, period)
    }
}
