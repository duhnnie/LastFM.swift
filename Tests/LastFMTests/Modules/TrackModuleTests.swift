import XCTest
@testable import LastFM

class TrackModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: TrackModule!
    private var apiClient = APIClientMock()

    override func setUpWithError() throws {
        instance = TrackModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }

    // scrobble

    func test_scrobble_success() throws {
        let jsonURL = Bundle.module.url(forResource: "Resources/track.scrobble", withExtension: "json")!
        let fakeData = try Data(contentsOf: jsonURL)
        let expectedEntity = try JSONDecoder().decode(ScrobbleList.self, from: fakeData)

        let track = ScrobbleParamItem(
            artist: "Pink Floyd",
            track: "Comfortably Numb",
            timestamp: 1697838599,
            album: "The Wall",
            albumArtist: "Pink Floyd"
        )

        let params = ScrobbleParams(sessionKey: "someKey", scrobbleItem: track)
        let expectedPayload = "sk=someKey&api_key=someAPIKey&api_sig=2ab59ea6792fd151d933da591583e5e7&albumArtist%5B0%5D=Pink%20Floyd&method=track.scrobble&album%5B0%5D=The%20Wall&timestamp%5B0%5D=1697838599&artist%5B0%5D=Pink%20Floyd&track%5B0%5D=Comfortably%20Numb"
        let expectation = expectation(description: "Waiting for scrobble")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.scrobble(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(_):
                XCTFail("Expected to succeed, but it failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(Util.areSameURL(
            "http://fakeDomain.com/?\(payload)",
            "http://fakeDomain.com/?\(expectedPayload)"
        ))

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )
    }

    func test_multiple_scrobble_success() throws {
        let jsonURL = Bundle.module.url(forResource: "Resources/track.multipleScrobble", withExtension: "json")!
        let fakeData = try Data(contentsOf: jsonURL)
        let expectedEntity = try JSONDecoder().decode(ScrobbleList.self, from: fakeData)
        var params = ScrobbleParams(sessionKey: "someKey")

        params.addItem(item: ScrobbleParamItem(
            artist: "+44",
            track: "Cliff Diving",
            timestamp: 1697843437,
            album: "When Your Heart Stops Beating",
            albumArtist: "+44"))

        params.addItem(item: ScrobbleParamItem(
            artist: "Broken Social Scene",
            track: "Cause = Time",
            date: Date(timeIntervalSince1970: 1697843377),
            album: "You Forgot It In People",
            albumArtist: "Broken Social Scene"))

        params.addItem(item: ScrobbleParamItem(
            artist: "Nine Inch Nails",
            track: "Branches / Bones",
            timestamp: 1697843317,
            album: "Not The Actual Events",
            albumArtist: "Nine Inch Nails"))

        params.addItem(item: ScrobbleParamItem(
            artist: "Llegas",
            track: "Viene El Sol",
            timestamp: 1697843257,
            album: "#VieneElSol",
            albumArtist: "Llegas"))

        params.addItem(item: ScrobbleParamItem(
            artist: "Foo Fighters",
            track: "Back & Forth",
            timestamp: 1697843197,
            album: "Wasting Light",
            albumArtist: "Foo Fighters"))

        let expectation = expectation(description: "Waiting for multiple scrobbling")

        let expectedPayload = "track%5B0%5D=Cliff%20Diving&album%5B0%5D=When%20Your%20Heart%20Stops%20Beating&album%5B1%5D=You%20Forgot%20It%20In%20People&album%5B3%5D=%23VieneElSol&albumArtist%5B0%5D=%2B44&albumArtist%5B2%5D=Nine%20Inch%20Nails&timestamp%5B0%5D=1697843437&timestamp%5B2%5D=1697843317&albumArtist%5B1%5D=Broken%20Social%20Scene&api_sig=7b5f4264dd5dd1b2dce180365eeb0cd2&artist%5B3%5D=Llegas&album%5B2%5D=Not%20The%20Actual%20Events&track%5B2%5D=Branches%20%2F%20Bones&timestamp%5B3%5D=1697843257&artist%5B1%5D=Broken%20Social%20Scene&api_key=someAPIKey&sk=someKey&track%5B1%5D=Cause%20%3D%20Time&album%5B4%5D=Wasting%20Light&artist%5B0%5D=%2B44&method=track.scrobble&track%5B3%5D=Viene%20El%20Sol&track%5B4%5D=Back%20%26%20Forth&albumArtist%5B3%5D=Llegas&timestamp%5B4%5D=1697843197&timestamp%5B1%5D=1697843377&artist%5B2%5D=Nine%20Inch%20Nails&artist%5B4%5D=Foo%20Fighters&albumArtist%5B4%5D=Foo%20Fighters"

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.scrobble(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(_):
                XCTFail("Expected to succeed, but it failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(Util.areSameURL(
            "http://fakeDomain.com/?\(payload)",
            "http://fakeDomain.com/?\(expectedPayload)"
        ))

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )
    }

    func test_invalid_sessionkey() throws {
        let jsonURL = Bundle.module.url(forResource: "Resources/invalidSessionKey", withExtension: "json")!
        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(
            description: "Expecting for scrobbling with invalid session key"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_403_FORBIDDEN

        try instance.scrobble(params: ScrobbleParams(sessionKey: "abcdefg")) { result in
            switch (result) {
            case .success(_):
                XCTFail("It was supossed to fail with a 403 server error")
            case .failure(let error):
                switch (error) {
                case .LastFMServiceError(let errorType, let errorMessage):
                    XCTAssertEqual(errorType, LastFMServiceErrorType.InvalidSessionKey)
                    XCTAssertEqual(errorMessage, "Invalid session key - Please re-authenticate")
                default:
                    XCTFail("It was supossed to be a LastFMServiceError")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func test_scrobble_ignored() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.scrobbleIgnored",
            withExtension: "json")!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for scrobbling with missing artist")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        // Here we sent any params since we already have fake the data to get from request
        try instance.scrobble(params: ScrobbleParams(sessionKey: "asdfasf")){ result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity.ignored, 5)
                XCTAssertEqual(entity.accepted, 1)
                XCTAssertEqual(entity.items.count, 6)

                XCTAssertEqual(entity.items[0].ignored, .NotIgnored)
                XCTAssertEqual(entity.items[0].artist.text, "Snail Mail")
                XCTAssertEqual(entity.items[0].track.text, "Pristine")
                XCTAssertEqual(entity.items[0].album.text, "Lush")
                XCTAssertEqual(entity.items[0].albumArtist.text, "Snail Mail")

                XCTAssertEqual(entity.items[1].ignored, .ArtistIgnored)
                XCTAssertNil(entity.items[1].artist.text)
                XCTAssertEqual(entity.items[1].track.text, "Our Work Of Art")
                XCTAssertEqual(entity.items[1].album.text!, "If These Streets Could Talk")
                XCTAssertEqual(entity.items[1].albumArtist.text, "Just Surrender")

                XCTAssertEqual(entity.items[2].ignored, .TrackIgnored)
                XCTAssertEqual(entity.items[2].artist.text, "+44")
                XCTAssertNil(entity.items[2].track.text)
                XCTAssertEqual(entity.items[2].album.text!, "When Your Heart Stops Beating")
                XCTAssertEqual(entity.items[2].albumArtist.text, "+44")

                XCTAssertEqual(entity.items[3].ignored, .TimestampTooOld)
                XCTAssertEqual(entity.items[3].artist.text, "Jamiroquai")
                XCTAssertEqual(entity.items[3].track.text, "Seven Days In Sunny June")
                XCTAssertEqual(entity.items[3].album.text!, "Dynamite")
                XCTAssertEqual(entity.items[3].albumArtist.text, "Jamiroquai")

                XCTAssertEqual(entity.items[4].ignored, .TimestampTooNew)
                XCTAssertEqual(entity.items[4].artist.text, "Soccer Mommy")
                XCTAssertEqual(entity.items[4].track.text, "Flaw")
                XCTAssertEqual(entity.items[4].album.text!, "Clean")
                XCTAssertEqual(entity.items[4].albumArtist.text, "Soccer Mommy")

                XCTAssertEqual(entity.items[5].ignored, .DailyScrobbleLimitExceeded)
                XCTAssertEqual(entity.items[5].artist.text, "Broken Social Scene")
                XCTAssertEqual(entity.items[5].track.text, "Cause = Time")
                XCTAssertEqual(entity.items[5].album.text!, "You Forgot It In People")
                XCTAssertEqual(entity.items[5].albumArtist.text, "Broken Social Scene")
            case .failure(let error):
                XCTFail("Expected to succeed but error \(error) was gotten")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func test_love_success() throws {
        let expectation = expectation(description: "waiting for love track request")
        let params = TrackLoveParams(
            track: "SomeTrack",
            artist: "SomeArtist",
            sessionKey: "someSessionKey"
        )

        let expectedPayload = "sk=someSessionKey&track=SomeTrack&artist=SomeArtist&method=track.love&api_sig=c993788654294e65dc11ce48d6af0fab&api_key=someAPIKey"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.love(params: params) { error in
            if error != nil {
                XCTFail("It was suppossed to succeed, but it failed with error \(error!.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(Util.areSameURL(
            "http://fakeDomain.com/?\(payload)",
            "http://fakeDomain.com/?\(expectedPayload)"
        ))

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )
    }

    func test_unlove_success() throws {
        let expectation = expectation(description: "waiting for unlove track request")
        let params = TrackLoveParams(
            track: "SomeTrack",
            artist: "SomeArtist",
            sessionKey: "someSessionKey"
        )

        let expectedPayload = "sk=someSessionKey&track=SomeTrack&artist=SomeArtist&method=track.unlove&api_sig=481b0418b5318df585faff2d8da9e0bf&api_key=someAPIKey"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.unlove(params: params) { error in
            if error != nil {
                XCTFail("It was suppossed to succeed, but it failed with error \(error!.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(Util.areSameURL(
            "http://fakeDomain.com/?\(payload)",
            "http://fakeDomain.com/?\(expectedPayload)"
        ))

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )
    }

    func test_update_now_playing_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.updateNowPlaying",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = TrackNowPlayingParams(
            artist: "Soccer Mommy",
            track: "Flaw",
            album: "Clean",
            albumArtist: "Soccer Mpmmy",
            sessionKey: "someSessionKey"
        )

        let expectedPayload = "track=Flaw&albumArtist=Soccer%20Mpmmy&api_key=someAPIKey&method=track.updateNowPlaying&sk=someSessionKey&api_sig=375e3e8321c7161de5d6c3fc89bb33e1&album=Clean&artist=Soccer%20Mommy"
        let expectation = expectation(description: "Waiting for now playing update")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.updateNowPlaying(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity.albumArtist.corrected, false)
                XCTAssertEqual(entity.albumArtist.text, "Soccer Mommy")
                XCTAssertEqual(entity.album.corrected, false)
                XCTAssertEqual(entity.album.text, "Clean")
                XCTAssertEqual(entity.track.corrected, false)
                XCTAssertEqual(entity.track.text, "Flaw")
                XCTAssertEqual(entity.artist.corrected, false)
                XCTAssertEqual(entity.artist.text, "Soccer Mommy")
                XCTAssertEqual(entity.ignored.rawValue, 0)
            case .failure(_):
                XCTFail("Expected to succeed, but it failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(Util.areSameURL(
            "http://fakeDomain.com/?\(payload)",
            "http://fakeDomain.com/?\(expectedPayload)"
        ))

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )
    }

    func test_getTrackInfo_by_artist_name_no_username_and_no_mbid_in_response() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getInfo_withTrackArtist_noUsername_noMBID",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "watiting for getTrackInfo")

        let params = TrackInfoParams(
            artist: "Some Artist",
            track: "Some Track",
            autocorrect: true,
            username: nil
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let trackInfo):
                XCTAssertEqual(trackInfo.name, "Some Track")
                XCTAssertNil(trackInfo.mbid)
                XCTAssertEqual(trackInfo.url.absoluteString, "https://sometrack.com")
                XCTAssertEqual(trackInfo.duration, 302000)
                XCTAssertEqual(trackInfo.streamable, false)
                XCTAssertEqual(trackInfo.listeners, 19)
                XCTAssertEqual(trackInfo.playcount, 136)
                XCTAssertEqual(trackInfo.artist.name, "Some Artist")
                XCTAssertEqual(trackInfo.artist.url.absoluteString, "https://someartist.com")
                XCTAssertEqual(trackInfo.album.artist, "Some Artist")
                XCTAssertEqual(trackInfo.album.title, "Some Album")
                XCTAssertEqual(trackInfo.album.url.absoluteString, "https://somealbum.com")
                XCTAssertNil(trackInfo.album.images.small)
                XCTAssertNil(trackInfo.album.images.medium)
                XCTAssertNil(trackInfo.album.images.large)
                XCTAssertNil(trackInfo.album.images.extraLarge)
                XCTAssertNil(trackInfo.album.images.mega)
                XCTAssertNil(trackInfo.userLoved)
                XCTAssertNil(trackInfo.userPlaycount)
                XCTAssertEqual(trackInfo.topTags.count, 0)
                XCTAssertNil(trackInfo.wiki)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?api_key=someAPIKey&track=Some%20Track&format=json&method=track.getInfo&artist=Some%20Artist&autocorrect=1"
            )
        )
    }

    func test_getTrackInfo_by_artist_name_with_username_and_no_mbid_in_response() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getInfo_withTrackArtist_withUsername_noMBID",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "watiting for getTrackInfo")

        let params = TrackInfoParams(
            artist: "Some Artist",
            track: "Some Track",
            autocorrect: true,
            username: "pepiro"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let trackInfo):
                XCTAssertEqual(trackInfo.name, "Some Track")
                XCTAssertNil(trackInfo.mbid)
                XCTAssertEqual(trackInfo.url.absoluteString, "https://sometrack.com")
                XCTAssertEqual(trackInfo.duration, 302000)
                XCTAssertEqual(trackInfo.streamable, false)
                XCTAssertEqual(trackInfo.listeners, 19)
                XCTAssertEqual(trackInfo.playcount, 136)
                XCTAssertEqual(trackInfo.artist.name, "Some Artist")
                XCTAssertEqual(trackInfo.artist.url.absoluteString, "https://someartist.com")
                XCTAssertEqual(trackInfo.album.artist, "Some Artist")
                XCTAssertEqual(trackInfo.album.title, "Some Album")
                XCTAssertEqual(trackInfo.album.url.absoluteString, "https://somealbum.com")
                XCTAssertNil(trackInfo.album.images.small)
                XCTAssertNil(trackInfo.album.images.medium)
                XCTAssertNil(trackInfo.album.images.large)
                XCTAssertNil(trackInfo.album.images.extraLarge)
                XCTAssertNil(trackInfo.album.images.mega)
                XCTAssertEqual(trackInfo.userLoved, true)
                XCTAssertEqual(trackInfo.userPlaycount, 48)
                XCTAssertEqual(trackInfo.topTags.count, 0)
                XCTAssertNil(trackInfo.wiki)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?api_key=someAPIKey&track=Some%20Track&format=json&method=track.getInfo&artist=Some%20Artist&autocorrect=1&username=pepiro"
            )
        )
    }

    func test_getTrackInfo_by_mbid_no_username() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getInfo_withMBID_noUsername",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "watiting for getTrackInfo")
        let params = TrackInfoByMBIDParams(mbid: "someTrackMBID")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let trackInfo):
                XCTAssertEqual(trackInfo.name, "Some Track")
                XCTAssertEqual(trackInfo.mbid!, "someTrackMBID")
                XCTAssertEqual(trackInfo.url.absoluteString, "https://sometrack.com")
                XCTAssertEqual(trackInfo.duration, 302000)
                XCTAssertEqual(trackInfo.streamable, false)
                XCTAssertEqual(trackInfo.listeners, 19)
                XCTAssertEqual(trackInfo.playcount, 136)
                XCTAssertEqual(trackInfo.artist.name, "Some Artist")
                XCTAssertEqual(trackInfo.artist.url.absoluteString, "https://someartist.com")
                XCTAssertEqual(trackInfo.album.artist, "Some Artist")
                XCTAssertEqual(trackInfo.album.title, "Some Album")
                XCTAssertEqual(trackInfo.album.url.absoluteString, "https://somealbum.com")

                XCTAssertEqual(
                    trackInfo.album.images.small?.absoluteString,
                    "https://images.com/s.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.medium?.absoluteString,
                    "https://images.com/m.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.large?.absoluteString,
                    "https://images.com/l.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.extraLarge?.absoluteString,
                    "https://images.com/xl.png"
                )

                XCTAssertNil(trackInfo.album.images.mega)
                XCTAssertNil(trackInfo.userLoved)
                XCTAssertNil(trackInfo.userPlaycount)
                XCTAssertEqual(trackInfo.topTags.count, 4)
                XCTAssertNotNil(trackInfo.wiki)

                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.year = 2008
                dateComponents.month = 7
                dateComponents.day = 23
                dateComponents.hour = 20
                dateComponents.minute = 9
                dateComponents.timeZone = TimeZone(secondsFromGMT: 0)

                let publishedDate = Calendar.current.date(from: dateComponents)
                XCTAssertEqual(trackInfo.wiki?.published, publishedDate)

                XCTAssertEqual(trackInfo.wiki?.summary, "Some summary")
                XCTAssertEqual(trackInfo.wiki?.content, "Some content")
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?api_key=someAPIKey&format=json&method=track.getInfo&mbid=someTrackMBID&autocorrect=1"
            )
        )
    }

    func test_getTrackInfo_by_mbid_with_username() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getInfo_withMBID_withUsername",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "watiting for getTrackInfo")
        let params = TrackInfoByMBIDParams(mbid: "someTrackMBID", username: "pepiro")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let trackInfo):
                XCTAssertEqual(trackInfo.name, "Some Track")
                XCTAssertEqual(trackInfo.mbid!, "someTrackMBID")
                XCTAssertEqual(trackInfo.url.absoluteString, "https://sometrack.com")
                XCTAssertEqual(trackInfo.duration, 302000)
                XCTAssertEqual(trackInfo.streamable, false)
                XCTAssertEqual(trackInfo.listeners, 19)
                XCTAssertEqual(trackInfo.playcount, 136)
                XCTAssertEqual(trackInfo.artist.name, "Some Artist")
                XCTAssertEqual(trackInfo.artist.url.absoluteString, "https://someartist.com")
                XCTAssertEqual(trackInfo.album.artist, "Some Artist")
                XCTAssertEqual(trackInfo.album.title, "Some Album")
                XCTAssertEqual(trackInfo.album.url.absoluteString, "https://somealbum.com")

                XCTAssertEqual(
                    trackInfo.album.images.small?.absoluteString,
                    "https://images.com/s.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.medium?.absoluteString,
                    "https://images.com/m.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.large?.absoluteString,
                    "https://images.com/l.png"
                )

                XCTAssertEqual(
                    trackInfo.album.images.extraLarge?.absoluteString,
                    "https://images.com/xl.png"
                )

                XCTAssertNil(trackInfo.album.images.mega)
                XCTAssertEqual(trackInfo.userLoved, false)
                XCTAssertEqual(trackInfo.userPlaycount, 13)
                XCTAssertEqual(trackInfo.topTags.count, 4)
                XCTAssertNotNil(trackInfo.wiki)

                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.year = 2008
                dateComponents.month = 7
                dateComponents.day = 23
                dateComponents.hour = 20
                dateComponents.minute = 9
                dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
                
                let publishedDate = Calendar.current.date(from: dateComponents)
                XCTAssertEqual(trackInfo.wiki?.published, publishedDate)

                XCTAssertEqual(trackInfo.wiki?.summary, "Some summary")
                XCTAssertEqual(trackInfo.wiki?.content, "Some content")
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?api_key=someAPIKey&format=json&method=track.getInfo&mbid=someTrackMBID&autocorrect=1&username=pepiro"
            )
        )
    }

}
