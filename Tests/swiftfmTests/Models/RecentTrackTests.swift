//
//  RecentTrackTests.swift
//  
//
//  Created by Daniel on 6/10/23.
//

import XCTest
@testable import swiftfm

class RecentTrackTests: XCTestCase {

    static private let defaultValues: [String: Any] = [
        "artistMBID": "someArtistMBID",
        "artistName": "someArtistName",
        "streamable": false,
        "imageSmall": "https://some.sm/image.jpg",
        "imageMedium": "https://some.md/image.jpg",
        "imageLarge": "https://some.lg/image.jpg",
        "imageExtraLarge": "http://some.xl/image.jpg",
        "mbid": "someMBID",
        "albumMBID": "someAlbumMBID",
        "albumName": "someAlbumName",
        "name": "someTrackName",
        "url": "https://some.track/url",
        "nowPlaying": false,
        "date": Date(timeIntervalSince1970: 1696622288)
    ]

    static private func generateJSON(
        artistMBID: String = defaultValues["artistMBID"] as! String,
        artistName: String = defaultValues["artistName"] as! String,
        streamable: Bool = defaultValues["streamable"] as! Bool,
        imageSmall: String = defaultValues["imageSmall"] as! String,
        imageMedium: String = defaultValues["imageMedium"] as! String,
        imageLarge: String = defaultValues["imageLarge"] as! String,
        imageExtraLarge: String = defaultValues["imageExtraLarge"] as! String,
        mbid: String = defaultValues["mbid"] as! String,
        albumMBID: String = defaultValues["albumMBID"] as! String,
        albumName: String = defaultValues["albumName"] as! String,
        name: String = defaultValues["name"] as! String,
        url: String = defaultValues["url"] as! String,
        nowPlaying: Bool = defaultValues["nowPlaying"] as! Bool,
        date: Date? = defaultValues["date"] as! Date
    ) -> Data {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"

        return """
{
  "artist": {
    "mbid": "\(artistMBID)",
    "#text": "\(artistName)"
  },
  "streamable": "\(streamable ? 1 : 0)",
  "image": [
    {
      "size": "small",
      "#text": "\(imageSmall)"
    },
    {
      "size": "medium",
      "#text": "\(imageMedium)"
    },
    {
      "size": "large",
      "#text": "\(imageLarge)"
    },
    {
      "size": "extralarge",
      "#text": "\(imageExtraLarge)"
    }
  ],
  "mbid": "\(mbid)",
  "album": {
    "mbid": "\(albumMBID)",
    "#text": "\(albumName)"
  },
  "name": "\(name)",
  \(
    date != nil
    ? """
    "date": {
      "uts": "\(Int(date!.timeIntervalSince1970))",
      "#text": "\(formatter.string(from: date!))"
    },
    """
    : ""
  )
  \(
    nowPlaying
    ? """
    "@attr": {
        "nowplaying": "true"
    },
    """
    : ""
  )
  "url": "\(url)"
}
""".data(using: .utf8)!
    }

    func testSuccessfulDefaultDecoding() throws {
        let data = Self.generateJSON()
        print(String(data: data, encoding: .utf8)!)
        let recentTrack = try JSONDecoder().decode(RecentTrack.self, from: data)

        XCTAssertEqual(
            recentTrack.mbid,
            Self.defaultValues["mbid"] as! String
        )
        XCTAssertEqual(recentTrack.name, Self.defaultValues["name"] as! String)
        XCTAssertEqual(
            recentTrack.artist.mbid,
            Self.defaultValues["artistMBID"] as! String
        )
        XCTAssertEqual(recentTrack.artist.name, Self.defaultValues["artistName"] as! String)
        XCTAssertEqual(recentTrack.album.mbid, Self.defaultValues["albumMBID"] as! String)
        XCTAssertEqual(recentTrack.album.name, Self.defaultValues["albumName"] as! String)
        XCTAssertEqual(recentTrack.url.absoluteString, Self.defaultValues["url"] as! String)

        let unwrappedDate = try XCTUnwrap(recentTrack.date)
        XCTAssertEqual(unwrappedDate, Self.defaultValues["date"] as! Date)

        let unwrappedImageSmall = try XCTUnwrap(recentTrack.images.small)
        XCTAssertEqual(unwrappedImageSmall.absoluteString, Self.defaultValues["imageSmall"] as! String)

        let unwrappedImageMedium = try XCTUnwrap(recentTrack.images.medium)
        XCTAssertEqual(unwrappedImageMedium.absoluteString, Self.defaultValues["imageMedium"] as! String)

        let unwrappedImageLarge = try XCTUnwrap(recentTrack.images.large)
        XCTAssertEqual(unwrappedImageLarge.absoluteString, Self.defaultValues["imageLarge"] as! String)

        let unwrappedImageExtraLarge = try XCTUnwrap(recentTrack.images.extraLarge)
        XCTAssertEqual(unwrappedImageExtraLarge.absoluteString, Self.defaultValues["imageExtraLarge"] as! String)

        XCTAssertEqual(
            recentTrack.streamable,
            Self.defaultValues["streamable"] as! Bool
        )
        XCTAssertEqual(
            recentTrack.nowPlaying,
            Self.defaultValues["nowPlaying"] as! Bool
        )
    }

    func testSuccessfulDecodingStreamable() throws {
        let data = Self.generateJSON(streamable: true)
        let recentTrack = try JSONDecoder().decode(RecentTrack.self, from: data)

        XCTAssertEqual(recentTrack.streamable, true)
    }

    func testSuccessfulDecodingWithNoDate() throws {
        let data = Self.generateJSON(date: nil)
        let recentTrack = try JSONDecoder().decode(RecentTrack.self, from: data)

        XCTAssertNil(recentTrack.date)
    }

    func testSuccesfulDecodingNowPlaying() throws {
        let data = Self.generateJSON(nowPlaying: true)
        let recentTrack = try JSONDecoder().decode(RecentTrack.self, from: data)

        XCTAssertTrue(recentTrack.nowPlaying)
    }
}