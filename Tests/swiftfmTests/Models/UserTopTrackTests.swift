//
//  UserTopTrackTests.swift
//  
//
//  Created by Daniel on 11/10/23.
//

import XCTest
@testable import swiftfm

class UserTopTrackTests: XCTestCase {

    static private let defaultValues = UserTopTracksTestUtils.defaultValues

    func testSuccessfulDecoding() throws {
        let data = UserTopTracksTestUtils.generateJSON().data(using: .utf8)!
        let userTopTrack = try JSONDecoder().decode(UserTopTrack.self, from: data)

        XCTAssertEqual(userTopTrack.streamable, Self.defaultValues[.streamable] as! Bool)
        XCTAssertEqual(userTopTrack.mbid, Self.defaultValues[.mbid] as! String)
        XCTAssertEqual(userTopTrack.name, Self.defaultValues[.name] as! String)
        XCTAssertEqual(userTopTrack.images.small!.absoluteString, Self.defaultValues[.imageSmall] as! String)
        XCTAssertEqual(userTopTrack.images.medium!.absoluteString, Self.defaultValues[.imageMedium] as! String)
        XCTAssertEqual(userTopTrack.images.large!.absoluteString, Self.defaultValues[.imageLarge] as! String)
        XCTAssertEqual(userTopTrack.images.extraLarge!.absoluteString, Self.defaultValues[.imageExtraLarge] as! String)
        XCTAssertEqual(userTopTrack.artist.url.absoluteString, Self.defaultValues[.artistURL] as! String)
        XCTAssertEqual(userTopTrack.artist.name, Self.defaultValues[.artistName] as! String)
        XCTAssertEqual(userTopTrack.artist.mbid, Self.defaultValues[.artistMBID] as! String)
        XCTAssertEqual(userTopTrack.url.absoluteString, Self.defaultValues[.url] as! String)
        XCTAssertEqual(userTopTrack.duration, UInt(Self.defaultValues[.duration] as! String)!)
        XCTAssertEqual(userTopTrack.rank, UInt(Self.defaultValues[.rank] as! String)!)
        XCTAssertEqual(userTopTrack.playcount, UInt(Self.defaultValues[.playcount] as! String)!)
    }

    func testUnsuccessfulDecodingDueRankDurationPlaycount() throws {
        var data = UserTopTracksTestUtils.generateJSON(
            rank: "not a valid rank"
        ).data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))

        data = UserTopTracksTestUtils.generateJSON(
            duration: "not a valid duration"
        ).data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))

        data = UserTopTracksTestUtils.generateJSON(
            playcount: "not a valid playcount"
        ).data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))
    }
}
