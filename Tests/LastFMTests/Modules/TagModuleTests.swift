import XCTest
@testable import LastFM

class TagModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: TagModule!
    private var apiClientMock = APIClientMock()

    override func setUpWithError() throws {
        instance = TagModule(
            parent: Self.lastFM,
            requester: RequestUtils(apiClient: apiClientMock)
        )
    }

    override func tearDownWithError() throws {
        apiClientMock.clearMock()
    }

    // getTopTracks

    func test_getTopTracks_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/tag.getTopTracks", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)

        let params = SearchParams(term: "Pop punk", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for getTopTracks")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let topTracks):
                XCTAssertEqual(topTracks.items.count, 2)
                XCTAssertEqual(topTracks.pagination.page, 1)
                XCTAssertEqual(topTracks.pagination.perPage, 2)
                XCTAssertEqual(topTracks.pagination.totalPages, 12)
                XCTAssertEqual(topTracks.pagination.total, 24)

                XCTAssertEqual(topTracks.items[0].name, "Track 0")
                XCTAssertEqual(topTracks.items[0].duration, 400)
                XCTAssertEqual(topTracks.items[0].mbid, "track-0-mbid")
                XCTAssertEqual(topTracks.items[0].url.absoluteString, "https://tracks.com/track-0")
                XCTAssertEqual(topTracks.items[0].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[0].artist.name, "Artist 0")
                XCTAssertEqual(topTracks.items[0].artist.mbid, "artist-0-mbid")
                XCTAssertEqual(topTracks.items[0].artist.url.absoluteString, "https://artists.com/artist-0")
                XCTAssertEqual(topTracks.items[0].image.small?.absoluteString, "https://images.com/artist-0-s.png")
                XCTAssertEqual(topTracks.items[0].image.medium?.absoluteString, "https://images.com/artist-0-m.png")
                XCTAssertEqual(topTracks.items[0].image.large?.absoluteString, "https://images.com/artist-0-l.png")
                XCTAssertEqual(topTracks.items[0].image.extraLarge?.absoluteString, "https://images.com/artist-0-xl.png")
                XCTAssertEqual(topTracks.items[0].rank, 1)

                XCTAssertEqual(topTracks.items[1].name, "Track 1")
                XCTAssertEqual(topTracks.items[1].duration, 410)
                XCTAssertEqual(topTracks.items[1].mbid, "track-1-mbid")
                XCTAssertEqual(topTracks.items[1].url.absoluteString, "https://tracks.com/track-1")
                XCTAssertEqual(topTracks.items[1].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[1].artist.name, "Artist 1")
                XCTAssertEqual(topTracks.items[1].artist.mbid, "artist-1-mbid")
                XCTAssertEqual(topTracks.items[1].artist.url.absoluteString, "https://artists.com/artist-1")
                XCTAssertEqual(topTracks.items[1].image.small?.absoluteString, "https://images.com/artist-1-s.png")
                XCTAssertEqual(topTracks.items[1].image.medium?.absoluteString, "https://images.com/artist-1-m.png")
                XCTAssertEqual(topTracks.items[1].image.large?.absoluteString, "https://images.com/artist-1-l.png")
                XCTAssertEqual(topTracks.items[1].image.extraLarge?.absoluteString, "https://images.com/artist-1-xl.png")
                XCTAssertEqual(topTracks.items[1].rank, 2)
            case .failure(let error):
                XCTFail("Expected to fail. Got \"\(error.localizedDescription)\" error instead")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertNil(apiClientMock.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=tag.gettoptracks&api_key=\(Constants.API_KEY)&limit=5&format=json&tag=Pop%20punk&page=1"
            )
        )
    }

    func test_getTopTracks_failure() throws {
        let params = SearchParams(term: "Some Tag", limit: 35, page: 5)

        apiClientMock.error = RuntimeError("Some error")

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }

    // getTopArtists

    func test_getTopArtists_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/tag.getTopArtists",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = SearchParams(term: "Progressive", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for getTopArtists")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getTopArtists(params: params) { result in
            switch(result) {
            case .success(let topArtists):
                XCTAssertEqual(topArtists.items.count, 2)
                XCTAssertEqual(topArtists.pagination.page, 1)
                XCTAssertEqual(topArtists.pagination.perPage, 2)
                XCTAssertEqual(topArtists.pagination.total, 100)
                XCTAssertEqual(topArtists.pagination.totalPages, 50)

                XCTAssertEqual(topArtists.items[0].name, "Artist 0")
                XCTAssertEqual(topArtists.items[0].mbid, "artist-0-mbid")
                XCTAssertEqual(topArtists.items[0].url.absoluteString, "https://artists.com/artist-0")
                XCTAssertEqual(topArtists.items[0].streamable, false)
                XCTAssertEqual(topArtists.items[0].image.small?.absoluteString, "https://images.com/artist-0-s.png")
                XCTAssertEqual(topArtists.items[0].image.medium?.absoluteString, "https://images.com/artist-0-m.png")
                XCTAssertEqual(topArtists.items[0].image.large?.absoluteString, "https://images.com/artist-0-l.png")
                XCTAssertEqual(topArtists.items[0].image.extraLarge?.absoluteString, "https://images.com/artist-0-xl.png")
                XCTAssertEqual(topArtists.items[0].image.mega?.absoluteString, "https://images.com/artist-0-mg.png")
                XCTAssertEqual(topArtists.items[0].rank, 1)

                XCTAssertEqual(topArtists.items[1].name, "Artist 1")
                XCTAssertNil(topArtists.items[1].mbid)
                XCTAssertEqual(topArtists.items[1].url.absoluteString, "https://artists.com/artist-1")
                XCTAssertEqual(topArtists.items[1].streamable, false)
                XCTAssertEqual(topArtists.items[1].image.small?.absoluteString, "https://images.com/artist-1-s.png")
                XCTAssertEqual(topArtists.items[1].image.medium?.absoluteString, "https://images.com/artist-1-m.png")
                XCTAssertEqual(topArtists.items[1].image.large?.absoluteString, "https://images.com/artist-1-l.png")
                XCTAssertEqual(topArtists.items[1].image.extraLarge?.absoluteString, "https://images.com/artist-1-xl.png")
                XCTAssertEqual(topArtists.items[1].image.mega?.absoluteString, "https://images.com/artist-1-mg.png")
                XCTAssertEqual(topArtists.items[1].rank, 2)
            case .failure(let error):
                XCTFail("Expected to fail. Got \"\(error.localizedDescription)\" error instead")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertNil(apiClientMock.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=tag.gettopartists&api_key=\(Constants.API_KEY)&limit=5&format=json&tag=Progressive&page=1"
            )
        )

    }

    func test_getTopAlbums_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/tag.getTopAlbums", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = SearchParams(term: "Experimental", limit: 5, page: 12)
        let expectation = expectation(description: "waiting for getTopAlbums")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getTopAlbums(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity.items.count, 5)
                XCTAssertEqual(entity.items[0].artist.name, "Grimes")

                XCTAssertEqual(
                    entity.items[0].artist.mbid,
                    "7e5a2a59-6d9f-4a17-b7c2-e1eedb7bd222"
                )

                XCTAssertEqual(
                    entity.items[0].artist.url.absoluteString,
                    "https://www.last.fm/music/Grimes"
                )

                XCTAssertEqual(
                    entity.items[0].image.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/c403c8620830e646a8f9eabcadb8c8a7.png"
                )

                XCTAssertEqual(
                    entity.items[0].image.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/c403c8620830e646a8f9eabcadb8c8a7.png"
                )

                XCTAssertEqual(
                    entity.items[0].image.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/c403c8620830e646a8f9eabcadb8c8a7.png"
                )

                XCTAssertEqual(
                    entity.items[0].image.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/c403c8620830e646a8f9eabcadb8c8a7.png"
                )

                XCTAssertNil(entity.items[0].image.mega)
                XCTAssertEqual(entity.items[0].rank, 1)
                XCTAssertEqual(entity.pagination.page, 1)
                XCTAssertEqual(entity.pagination.perPage, 5)
                XCTAssertEqual(entity.pagination.total, 38538)
                XCTAssertEqual(entity.pagination.totalPages, 7708)
            case .failure(let error):
                XCTFail("Expected to succeed, but it fail with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=tag.gettopalbums&tag=Experimental&limit=5&page=12&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    // getInfo

    func test_getInfo() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/tag.getInfo",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getInfo")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getInfo(name: "indie", lang: "en") { result in
            switch (result) {
            case .success(let tagInfo):
                XCTAssertEqual(tagInfo.name, "indie")
                XCTAssertEqual(tagInfo.total, 2046784)
                XCTAssertEqual(tagInfo.reach, 257873)
                XCTAssertEqual(tagInfo.wiki.summary, "Indie tag summary.")
                XCTAssertEqual(tagInfo.wiki.content, "Indie tag content.")
            case .failure(let error):
                XCTFail("Expected to succeed, but it fail with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)
        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=tag.getinfo&format=json&name=indie&lang=en&api_key=someAPIKey"
            )
        )
    }

    func test_getWeeklyChartList_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/tag.getWeeklyChartList",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getWeeklyChartList()")

        apiClientMock.response = Constants.RESPONSE_200_OK
        apiClientMock.data = fakeData

        instance.getWeeklyChartList(tag: "alternative rock") { result in
            switch (result) {
            case .success(let chartList):
                XCTAssertEqual(chartList.items.count, 2)
                XCTAssertEqual(chartList.items[0].from, 1108296000)
                XCTAssertEqual(chartList.items[0].to, 1108900800)

                XCTAssertEqual(chartList.items[1].from, 1108900800)
                XCTAssertEqual(chartList.items[1].to, 1109505600)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed, error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                "http://ws.audioscrobbler.com/2.0?format=json&tag=alternative%20rock&method=tag.getweeklychartlist&api_key=someAPIKey",
                apiClientMock.getCalls[0].url.absoluteString
            )
        )
    }

    
}
