//
//  UserTopTrackTests.swift
//  
//
//  Created by Daniel on 11/10/23.
//

import XCTest
@testable import swiftfm

class UserTopTrackTests: XCTestCase {

    static private let defaultValues: [String: Any] = [
        "streamable": false,
        "mbid": "someMBID",
        "name": "someTrackName",
        "imageSmall": "https://some.sm/image.jpg",
        "imageMedium": "https://some.md/image.jpg",
        "imageLarge": "https://some.lg/image.jpg",
        "imageExtraLarge": "http://some.xl/image.jpg",
        "artistMBID": "someArtistMBID",
        "artistName": "someArtistName",
        "artistURL": "https://someartist.com",
        "url": "https://some.track/url",
        "duration": "209",
        "rank": "6",
        "playcount": "329"
    ]

    private static func generateJSON(
        streamable: Bool = defaultValues["streamable"] as! Bool,
        mbid: String = defaultValues["mbid"] as! String,
        name: String = defaultValues["name"] as! String,
        imageSmall: String = defaultValues["imageSmall"] as! String,
        imageMedium: String = defaultValues["imageMedium"] as! String,
        imageLarge: String = defaultValues["imageLarge"] as! String,
        imageExtraLarge: String = defaultValues["imageExtraLarge"] as! String,
        artistMBID: String = defaultValues["artistMBID"] as! String,
        artistName: String = defaultValues["artistName"] as! String,
        artistURL: String = defaultValues["artistURL"] as! String,
        url: String = defaultValues["url"] as! String,
        duration: String = defaultValues["duration"] as! String,
        rank: String = defaultValues["rank"] as! String,
        playcount: String = defaultValues["playcount"] as! String
    ) -> Data {
        return """
{
  "streamable": {
    "fulltrack": "\(streamable ? "1" : "0")",
    "#text": "\(streamable ? "1" : "0")"
  },
  "mbid": "\(mbid)",
  "name": "\(name)",
  "image": \(LastFMImagesTests.generateJSON(
    small: imageSmall, medium: imageMedium, large: imageLarge, extraLarge: imageExtraLarge
)),
  "artist": {
    "url": "\(artistURL)",
    "name": "\(artistName)",
    "mbid": "\(artistMBID)"
  },
  "url": "\(url)",
  "duration": "\(duration)",
  "@attr": {
    "rank": "\(rank)"
  },
  "playcount": "\(playcount)"
}
""".data(using: .utf8)!
    }

    func testSuccessfulDecoding() throws {
        let data = Self.generateJSON()
        let userTopTrack = try JSONDecoder().decode(UserTopTrack.self, from: data)

        XCTAssertEqual(userTopTrack.streamable, Self.defaultValues["streamable"] as! Bool)
        XCTAssertEqual(userTopTrack.mbid, Self.defaultValues["mbid"] as! String)
        XCTAssertEqual(userTopTrack.name, Self.defaultValues["name"] as! String)
        XCTAssertEqual(userTopTrack.images.small!.absoluteString, Self.defaultValues["imageSmall"] as! String)
        XCTAssertEqual(userTopTrack.images.medium!.absoluteString, Self.defaultValues["imageMedium"] as! String)
        XCTAssertEqual(userTopTrack.images.large!.absoluteString, Self.defaultValues["imageLarge"] as! String)
        XCTAssertEqual(userTopTrack.images.extraLarge!.absoluteString, Self.defaultValues["imageExtraLarge"] as! String)
        XCTAssertEqual(userTopTrack.artist.url.absoluteString, Self.defaultValues["artistURL"] as! String)
        XCTAssertEqual(userTopTrack.artist.name, Self.defaultValues["artistName"] as! String)
        XCTAssertEqual(userTopTrack.artist.mbid, Self.defaultValues["artistMBID"] as! String)
        XCTAssertEqual(userTopTrack.url.absoluteString, Self.defaultValues["url"] as! String)
        XCTAssertEqual(userTopTrack.duration, UInt(Self.defaultValues["duration"] as! String)!)
        XCTAssertEqual(userTopTrack.rank, UInt(Self.defaultValues["rank"] as! String)!)
        XCTAssertEqual(userTopTrack.playcount, UInt(Self.defaultValues["playcount"] as! String)!)
    }

    func testUnsuccessfulDecodingDueRankDurationPlaycount() throws {
        var data = Self.generateJSON(rank: "not a valid rank")
        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))

        data = Self.generateJSON(rank: "not a valid duration")
        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))

        data = Self.generateJSON(rank: "not a valid playcount")
        XCTAssertThrowsError(try JSONDecoder().decode(UserTopTrack.self, from: data))
    }
}
