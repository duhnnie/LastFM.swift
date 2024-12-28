import XCTest
@testable import LastFM

class AlbumModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: AlbumModule!
    private var apiClient = APIClientMock()

    override func setUpWithError() throws {
        instance = AlbumModule(
            parent: Self.lastFM,
            secure: true,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }
    
    private func validateAlbumInfo(_ albumInfo: AlbumInfo) {
        XCTAssertEqual(albumInfo.artist, "Various Artists")
        XCTAssertEqual(albumInfo.mbid, "some-artist-mbid")

        XCTAssertEqual(albumInfo.tags.count, 3)
        XCTAssertEqual(albumInfo.tags[0].name, "industrial rock")
        XCTAssertEqual(albumInfo.tags[0].url.absoluteString, "https://www.last.fm/tag/industrial+rock")
        XCTAssertEqual(albumInfo.tags[1].name, "industrial")
        XCTAssertEqual(albumInfo.tags[1].url.absoluteString, "https://www.last.fm/tag/industrial")
        XCTAssertEqual(albumInfo.tags[2].name, "rock")
        XCTAssertEqual(albumInfo.tags[2].url.absoluteString, "https://www.last.fm/tag/rock")

        XCTAssertEqual(albumInfo.name, "Some Album Title")
        XCTAssertEqual(albumInfo.userPlaycount, 832)

        XCTAssertEqual(
            albumInfo.image.small?.absoluteString,
            "https://images.com/artist/small.png"
        )

        XCTAssertEqual(
            albumInfo.image.medium?.absoluteString,
            "https://images.com/artist/medium.png"
        )

        XCTAssertEqual(
            albumInfo.image.large?.absoluteString,
            "https://images.com/artist/large.png"
        )

        XCTAssertEqual(
            albumInfo.image.extraLarge?.absoluteString,
            "https://images.com/artist/extralarge.png"
        )

        XCTAssertEqual(
            albumInfo.image.mega?.absoluteString,
            "https://images.com/artist/mega.png"
        )

        XCTAssertEqual(albumInfo.tracks?.count, 5)

        XCTAssertEqual(albumInfo.tracks?[0].streamable, .noStreamable)
        XCTAssertEqual(albumInfo.tracks?[0].duration, 307)
        XCTAssertEqual(albumInfo.tracks?[0].url.absoluteString, "http://tracks.com/track-1")
        XCTAssertEqual(albumInfo.tracks?[0].name, "Track 1")
        XCTAssertEqual(albumInfo.tracks?[0].trackNumber, 1)
        XCTAssertEqual(albumInfo.tracks?[0].artist.url.absoluteString, "https://artists.com/artist-1")
        XCTAssertEqual(albumInfo.tracks?[0].artist.name, "Artist 1")
        XCTAssertEqual(albumInfo.tracks?[0].artist.mbid, "artist-1-mbid")

        XCTAssertEqual(albumInfo.tracks?[1].streamable, .noStreamable)
        XCTAssertEqual(albumInfo.tracks?[1].duration, 222)
        XCTAssertEqual(albumInfo.tracks?[1].url.absoluteString, "http://tracks.com/track-2")
        XCTAssertEqual(albumInfo.tracks?[1].name, "Track 2")
        XCTAssertEqual(albumInfo.tracks?[1].trackNumber, 2)
        XCTAssertEqual(albumInfo.tracks?[1].artist.url.absoluteString, "https://artists.com/artist-2")
        XCTAssertEqual(albumInfo.tracks?[1].artist.name, "Artist 2")
        XCTAssertEqual(albumInfo.tracks?[1].artist.mbid, "artist-2-mbid")

        XCTAssertEqual(albumInfo.tracks?[2].streamable, .noStreamable)
        XCTAssertEqual(albumInfo.tracks?[2].duration, nil)
        XCTAssertEqual(albumInfo.tracks?[2].url.absoluteString, "http://tracks.com/track-3")
        XCTAssertEqual(albumInfo.tracks?[2].name, "Track 3")
        XCTAssertEqual(albumInfo.tracks?[2].trackNumber, 3)
        XCTAssertEqual(albumInfo.tracks?[2].artist.url.absoluteString, "https://artists.com/artist-3")
        XCTAssertEqual(albumInfo.tracks?[2].artist.name, "Artist 3")
        XCTAssertEqual(albumInfo.tracks?[2].artist.mbid, "artist-3-mbid")

        XCTAssertEqual(albumInfo.tracks?[3].streamable, .noStreamable)
        XCTAssertEqual(albumInfo.tracks?[3].duration, 211)
        XCTAssertEqual(albumInfo.tracks?[3].url.absoluteString, "http://tracks.com/track-4")
        XCTAssertEqual(albumInfo.tracks?[3].name, "Track 4")
        XCTAssertEqual(albumInfo.tracks?[3].trackNumber, 4)
        XCTAssertEqual(albumInfo.tracks?[3].artist.url.absoluteString, "https://artists.com/artist-4")
        XCTAssertEqual(albumInfo.tracks?[3].artist.name, "Artist 4")
        XCTAssertEqual(albumInfo.tracks?[3].artist.mbid, "artist-4-mbid")

        XCTAssertEqual(albumInfo.tracks?[4].streamable, .noStreamable)
        XCTAssertEqual(albumInfo.tracks?[4].duration, 222)
        XCTAssertEqual(albumInfo.tracks?[4].url.absoluteString, "http://tracks.com/track-5")
        XCTAssertEqual(albumInfo.tracks?[4].name, "Track 5")
        XCTAssertEqual(albumInfo.tracks?[4].trackNumber, 5)
        XCTAssertEqual(albumInfo.tracks?[4].artist.url.absoluteString, "https://artists.com/artist-5")
        XCTAssertEqual(albumInfo.tracks?[4].artist.name, "Artist 5")
        XCTAssertEqual(albumInfo.tracks?[4].artist.mbid, "artist-5-mbid")

        XCTAssertEqual(albumInfo.listeners, 803026)
        XCTAssertEqual(albumInfo.playcount, 20522460)

        XCTAssertEqual(
            albumInfo.url.absoluteString,
            "https://albums.com/some-album"
        )

        let dateComponents = DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2023,
            month: 6,
            day: 6,
            hour: 6,
            minute: 30
        )

        XCTAssertEqual(
            albumInfo.wiki?.published,
            Calendar.current.date(from: dateComponents)!
        )

        XCTAssertEqual(albumInfo.wiki?.summary, "Some summary.")
        XCTAssertEqual(albumInfo.wiki?.content, "Some content.")
    }

    private func validateAlbumSearchResults(_ albumResults: SearchResults<AlbumSearchResult>) {
        XCTAssertEqual(albumResults.pagination.startPage, 1)
        XCTAssertEqual(albumResults.pagination.totalResults, 2)
        XCTAssertEqual(albumResults.pagination.startIndex, 0)
        XCTAssertEqual(albumResults.pagination.itemsPerPage, 5)

        XCTAssertEqual(albumResults.items[0].name, "Album 0")
        XCTAssertEqual(albumResults.items[0].artist, "Artist 0")
        XCTAssertEqual(albumResults.items[0].url.absoluteString, "https://albums.com/album-0")
        XCTAssertEqual(albumResults.items[0].image.small?.absoluteString, "https://images.com/album-0-s.png")
        XCTAssertEqual(albumResults.items[0].image.medium?.absoluteString, "https://images.com/album-0-m.png")
        XCTAssertEqual(albumResults.items[0].image.large?.absoluteString, "https://images.com/album-0-l.png")
        XCTAssertEqual(albumResults.items[0].image.extraLarge?.absoluteString, "https://images.com/album-0-xl.png")
        XCTAssertNil(albumResults.items[0].image.mega)
        XCTAssertEqual(albumResults.items[0].streamable, false)
        XCTAssertEqual(albumResults.items[0].mbid, "album-0-mbid")

        XCTAssertEqual(albumResults.items[1].name, "Album 1")
        XCTAssertEqual(albumResults.items[1].artist, "Artist 1")
        XCTAssertEqual(albumResults.items[1].url.absoluteString, "https://albums.com/album-1")
        XCTAssertEqual(albumResults.items[1].image.small?.absoluteString, "https://images.com/album-1-s.png")
        XCTAssertEqual(albumResults.items[1].image.medium?.absoluteString, "https://images.com/album-1-m.png")
        XCTAssertEqual(albumResults.items[1].image.large?.absoluteString, "https://images.com/album-1-l.png")
        XCTAssertEqual(albumResults.items[1].image.extraLarge?.absoluteString, "https://images.com/album-1-xl.png")
        XCTAssertNil(albumResults.items[1].image.mega)
        XCTAssertEqual(albumResults.items[1].streamable, false)
        XCTAssertEqual(albumResults.items[1].mbid, "album-1-mbid")
    }

    private func validateTags(_ tags: CollectionList<LastFMEntity>) {
        XCTAssertEqual(tags.items.count, 2)

        XCTAssertEqual(tags.items[0].name, "tag-1")
        XCTAssertEqual(tags.items[0].url.absoluteString, "https://tags.com/tag-1")

        XCTAssertEqual(tags.items[1].name, "tag-2")
        XCTAssertEqual(tags.items[1].url.absoluteString, "https://tags.com/tag-2")
    }

    private func validateTopTags(_ tags: CollectionList<TopTag>) {
        XCTAssertEqual(tags.items.count, 2)

        XCTAssertEqual(tags.items[0].name, "tag-a")
        XCTAssertEqual(tags.items[0].url.absoluteString, "https://tags.com/tag-a")
        XCTAssertEqual(tags.items[0].count, 100)

        XCTAssertEqual(tags.items[1].name, "tag-b")
        XCTAssertEqual(tags.items[1].url.absoluteString, "https://tags.com/tag-b")
        XCTAssertEqual(tags.items[1].count, 63)
    }

    // getTopTracks
    func test_getInfo_withUsername() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)

        let params = AlbumInfoParams(
            artist: "Various Artists",
            album: "Some Album Title",
            username: "pepe"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK
        
        let albumInfo = try await instance.getInfo(params: params)
        validateAlbumInfo(albumInfo)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&artist=Various%20Artists&username=pepe&format=json&album=Some%20Album%20Title&api_key=someAPIKey&autocorrect=1"
            )
        )
    }
    
    func test_getInfo_withUsername() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo with username")

        let params = AlbumInfoParams(
            artist: "Various Artists",
            album: "Some Album Title",
            username: "pepe"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let albumInfo):
                self.validateAlbumInfo(albumInfo)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&artist=Various%20Artists&username=pepe&format=json&album=Some%20Album%20Title&api_key=someAPIKey&autocorrect=1"
            )
        )
    }
    
    func test_getInfoByMBID_withUsername() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)

        let params = AlbumInfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: false,
            username: "pepe",
            lang: "pt"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK
        
        let _ = try await instance.getInfo(params: params)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&mbid=some-artist-mbid&username=pepe&format=json&lang=pt&autocorrect=0&api_key=someAPIKey"
            )
        )
    }

    func test_getInfoByMBID_withUsername() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo with username")

        let params = AlbumInfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: false,
            username: "pepe",
            lang: "pt"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(_):
                break
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&mbid=some-artist-mbid&username=pepe&format=json&lang=pt&autocorrect=0&api_key=someAPIKey"
            )
        )
    }

    func test_getInfo_noUsername() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)

        let params = AlbumInfoParams(
            artist: "Some Artist",
            album: "Some Album Title",
            autocorrect: false,
            lang: "fr"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        let albumInfo = try await instance.getInfo(params: params)
        XCTAssertNil(albumInfo.userPlaycount)
        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&artist=Some%20Artist&album=Some%20Album%20Title&format=json&lang=fr&autocorrect=0&api_key=someAPIKey"
            )
        )
    }

    func test_getInfo_noUsername() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo with username")

        let params = AlbumInfoParams(
            artist: "Some Artist",
            album: "Some Album Title",
            autocorrect: false,
            lang: "fr"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let albumInfo):
                XCTAssertNil(albumInfo.userPlaycount)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&artist=Some%20Artist&album=Some%20Album%20Title&format=json&lang=fr&autocorrect=0&api_key=someAPIKey"
            )
        )
    }

    func test_getInfoByMBID_noUsername() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)

        let params = AlbumInfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: true,
            lang: "pt"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        let albumInfo = try await instance.getInfo(params: params)

        XCTAssertNil(albumInfo.userPlaycount)
        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&mbid=some-artist-mbid&format=json&lang=pt&autocorrect=1&api_key=someAPIKey"
            )
        )
    }

    func test_getInfoByMBID_noUsername() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noUsername",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo with username")

        let params = AlbumInfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: true,
            lang: "pt"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let albumInfo):
                XCTAssertNil(albumInfo.userPlaycount)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=album.getinfo&mbid=some-artist-mbid&format=json&lang=pt&autocorrect=1&api_key=someAPIKey"
            )
        )
    }

    func test_getInfo_noTracks() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noTracks",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)

        let params = AlbumInfoParams(
            artist: "Some Artist",
            album: "Some Album Title",
            autocorrect: false,
            lang: "fr"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        let albumInfo = try await instance.getInfo(params: params)
        XCTAssertNil(albumInfo.tracks)
    }

    func test_getInfo_noTracks() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.getInfo_noTracks",
            withExtension: "json"
        )!

        let fakeDate = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo with username")

        let params = AlbumInfoParams(
            artist: "Some Artist",
            album: "Some Album Title",
            autocorrect: false,
            lang: "fr"
        )

        apiClient.data = fakeDate
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let albumInfo):
                XCTAssertNil(albumInfo.tracks)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func test_albumSearch() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.search",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = SearchParams(term: "album", limit: 34, page: 4)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        let albumResults = try await instance.search(params: params)

        validateAlbumSearchResults(albumResults)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                "https://ws.audioscrobbler.com/2.0?album=album&api_key=someAPIKey&page=4&format=json&method=album.search&limit=34",
                apiClient.asyncGetCalls[0].url.absoluteString
            )
        )
    }

    func test_albumSearch() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/album.search",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for search()")
        let params = SearchParams(term: "album", limit: 34, page: 4)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.search(params: params) { result in
            switch (result) {
            case .success(let albumResults):
                self.validateAlbumSearchResults(albumResults)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed. Error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                "https://ws.audioscrobbler.com/2.0?album=album&api_key=someAPIKey&page=4&format=json&method=album.search&limit=34",
                apiClient.getCalls[0].url.absoluteString
            )
        )
    }

    func test_addTags_success() async throws {
        let params = AlbumAddTagsParams(
            artist: "Some Artist",
            album: "Some Album",
            tags: ["tag 1", "tag-2", "tag3"]
        )

        let expectedPayload = "sk=key12345&tags=tag%201,tag-2,tag3&artist=Some%20Artist&album=Some%20Album&api_key=someAPIKey&method=album.addtags&api_sig=c4ce46fbec0ed5716ef25016d35f55dd"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try await instance.addTags(params: params, sessionKey: "key12345")

        XCTAssertEqual(apiClient.asyncPostCalls.count, 1)
        XCTAssertEqual(
            apiClient.asyncPostCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.asyncPostCalls[0].url.absoluteString,
            "https://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.asyncPostCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "https://domain.com/?" + payloadString,
                "https://domain.com/?" + expectedPayload
            )
        )
    }

    func test_addTags_success() throws {
        let expectation = expectation(description: "Waiting for addTags()")

        let params = AlbumAddTagsParams(
            artist: "Some Artist",
            album: "Some Album",
            tags: ["tag 1", "tag-2", "tag3"]
        )

        let expectedPayload = "sk=key12345&tags=tag%201,tag-2,tag3&artist=Some%20Artist&album=Some%20Album&api_key=someAPIKey&method=album.addtags&api_sig=c4ce46fbec0ed5716ef25016d35f55dd"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.addTags(params: params, sessionKey: "key12345") { error in
            if let error = error {
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)
        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "https://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "https://domain.com/?" + payloadString,
                "https://domain.com/?" + expectedPayload
            )
        )
    }

    func test_removeTag_success() async throws {
        let expectedPayload = "method=album.removetag&api_key=someAPIKey&api_sig=57ab1ed79627b879412f00420e0b12ab&artist=Artist%20A&sk=mySessionKey&tag=tag-32&album=Album%20A"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try await instance.removeTag(
            artist: "Artist A",
            album: "Album A",
            tag: "tag-32",
            sessionKey: "mySessionKey"
        )

        XCTAssertEqual(apiClient.asyncPostCalls.count, 1)
        XCTAssertEqual(
            apiClient.asyncPostCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.asyncPostCalls[0].url.absoluteString,
            "https://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.asyncPostCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "https://domain.com/?" + payloadString,
                "https://domain.com/?" + expectedPayload
            )
        )
    }

    func test_removeTag_success() throws {
        let expectation = expectation(description: "Waiting for removeTag()")

        let expectedPayload = "method=album.removetag&api_key=someAPIKey&api_sig=57ab1ed79627b879412f00420e0b12ab&artist=Artist%20A&sk=mySessionKey&tag=tag-32&album=Album%20A"

        apiClient.data = "{}".data(using: .utf8)
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.removeTag(
            artist: "Artist A",
            album: "Album A",
            tag: "tag-32",
            sessionKey: "mySessionKey") { error in
            if let error = error {
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)
        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "https://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "https://domain.com/?" + payloadString,
                "https://domain.com/?" + expectedPayload
            )
        )
    }

    func test_getTags_success() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = AlbumGetTagsParams(
            artist: "Some Artist",
            album: "Some Album",
            autocorrect: true,
            user: "pepiro"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        let tags = try await instance.getTags(params: params)

        validateTags(tags)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?artist=Some%20Artist&album=Some%20Album&autocorrect=1&user=pepiro&method=album.gettags&api_key=someAPIKey&format=json"
            )
        )
    }

    func test_getTags_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getTags()")

        let params = AlbumGetTagsParams(
            artist: "Some Artist",
            album: "Some Album",
            autocorrect: true,
            user: "pepiro"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTags(params: params) { result in
            switch (result) {
            case .success(let tags):
                self.validateTags(tags)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?artist=Some%20Artist&album=Some%20Album&autocorrect=1&user=pepiro&method=album.gettags&api_key=someAPIKey&format=json"
            )
        )
    }

    func test_getTagsByMBID_success() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = InfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: true,
            username: "pepiro"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        let _ = try await instance.getTags(params: params)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?mbid=some-artist-mbid&autocorrect=1&user=pepiro&method=album.gettags&api_key=someAPIKey&format=json"
            )
        )
    }

    func test_getTagsByMBID_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getTags()")

        let params = InfoByMBIDParams(
            mbid: "some-artist-mbid",
            autocorrect: true,
            username: "pepiro"
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTags(params: params) { result in
            switch (result) {
            case .success(_):
                break
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?mbid=some-artist-mbid&autocorrect=1&user=pepiro&method=album.gettags&api_key=someAPIKey&format=json"
            )
        )
    }
    
    func test_getTopTags_success() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTopTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        let tags = try await instance.getTopTags(
            artist: "Some Artist",
            album: "Some Album",
            autocorrect: true
        )

        validateTopTags(tags)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?artist=Some%20Artist&autocorrect=1&method=album.gettoptags&api_key=someAPIKey&album=Some%20Album&format=json"
            )
        )
    }

    func test_getTopTags_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTopTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getTopTags()")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTags(
            artist: "Some Artist",
            album: "Some Album",
            autocorrect: true
        ) { result in
            switch (result) {
            case .success(let tags):
                self.validateTopTags(tags)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?artist=Some%20Artist&autocorrect=1&method=album.gettoptags&api_key=someAPIKey&album=Some%20Album&format=json"
            )
        )
    }

    func test_getTopTagsByMBID_success() async throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTopTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        let _ = try await instance.getTopTags(mbid: "some-album-mbid", autocorrect: false)

        XCTAssertEqual(apiClient.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClient.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?mbid=some-album-mbid&autocorrect=0&method=album.gettoptags&api_key=someAPIKey&format=json"
            )
        )
    }

    func test_getTopTagsByMBID_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/track.getTopTags",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getTopTags()")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTags(mbid: "some-album-mbid", autocorrect: false) { result in
            switch (result) {
            case .success(_):
                break;
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed. Error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?mbid=some-album-mbid&autocorrect=0&method=album.gettoptags&api_key=someAPIKey&format=json"
            )
        )
    }

}
