//
//  ExtendedRecentTrackTests.swift
//  LastFM.swift
//
//  Created by Danielo on 6/2/26.
//

import XCTest
@testable import LastFM

class ExtendedRecentTrackTests: XCTestCase {
    
    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: AlbumModule!
    private var apiClient = APIClientMock()
    
    func test_encoding() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getExtendedRecentTracks",
            withExtension: "json"
        )!
        
        let data = try Data(contentsOf: jsonURL)
        
        let decodedData = try JSONSerialization.jsonObject(
            with: data,
            options: [.fragmentsAllowed]) as! NSDictionary
        
        let recentTracks = decodedData["recenttracks"] as! NSDictionary
        let tracks = recentTracks["track"] as! [NSDictionary]
        let playingNowTrack = tracks[0]
        let regularTrack = tracks[1]
        
        // Playing Now
        let dataPlayingNow = try JSONSerialization.data(withJSONObject: playingNowTrack)
        let decodedPlayingNow = try JSONDecoder().decode(ExtendedRecentTrack.self, from: dataPlayingNow)
        let encodedPlayingNow = try JSONEncoder().encode(decodedPlayingNow)
        
        XCTAssertTrue(
            Util.jsonDataEquals(dataPlayingNow, encodedPlayingNow),
            "Encoded data is different from original one (playing now)"
        )
        
        // Regular track
        let dataRegular = try JSONSerialization.data(withJSONObject: regularTrack)
        let decodedRegular = try JSONDecoder().decode(ExtendedRecentTrack.self, from: dataRegular)
        let encodedRegular = try JSONEncoder().encode(decodedRegular)
        
        XCTAssertTrue(
            Util.jsonDataEquals(dataRegular, encodedRegular),
            "Encoded data is different from original one (regular track)"
        )
    }
    
}
