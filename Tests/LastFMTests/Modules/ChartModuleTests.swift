import XCTest
@testable import LastFM

class ChartModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: ChartModule!
    private var apiClient = APIClientMock()

    override func setUpWithError() throws {
        instance = ChartModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }

    // getTopTracks

    func test_getTopTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/chart.getTopTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for successful getTopTracks")

        let params = ChartTopTracksParams(page: 1, limit: 5)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let topTracks):
                XCTAssertEqual(topTracks.items.count, 5)
                XCTAssertEqual(topTracks.items[0].name, "Track-0")
                XCTAssertEqual(topTracks.items[0].duration, 0)
                XCTAssertEqual(topTracks.items[0].playcount, 100)
                XCTAssertEqual(topTracks.items[0].listeners, 11)
                XCTAssertEqual(topTracks.items[0].mbid, "")
                XCTAssertEqual(topTracks.items[0].url.absoluteString, "http://tracks.com/track-0")
                XCTAssertEqual(topTracks.items[0].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[0].artist.name, "Artist-0")
                XCTAssertEqual(topTracks.items[0].artist.mbid, "artist-0-mbid")
                XCTAssertEqual(topTracks.items[0].artist.url.absoluteString, "https://artists.com/artist-0")
                XCTAssertEqual(topTracks.items[0].images.small?.absoluteString, "https://images.com/artist-0-small.png")
                XCTAssertEqual(topTracks.items[0].images.medium?.absoluteString, "https://images.com/artist-0-medium.png")
                XCTAssertEqual(topTracks.items[0].images.large?.absoluteString, "https://images.com/artist-0-large.png")
                XCTAssertEqual(topTracks.items[0].images.extraLarge?.absoluteString, "https://images.com/artist-0-extralarge.png")

                XCTAssertEqual(topTracks.items[1].name, "Track-1")
                XCTAssertEqual(topTracks.items[1].duration, 0)
                XCTAssertEqual(topTracks.items[1].playcount, 200)
                XCTAssertEqual(topTracks.items[1].listeners, 12)
                XCTAssertEqual(topTracks.items[1].mbid, "")
                XCTAssertEqual(topTracks.items[1].url.absoluteString, "http://tracks.com/track-1")
                XCTAssertEqual(topTracks.items[1].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[1].artist.name, "Artist-1")
                XCTAssertEqual(topTracks.items[1].artist.mbid, "artist-1-mbid")
                XCTAssertEqual(topTracks.items[1].artist.url.absoluteString, "https://artists.com/artist-1")
                XCTAssertEqual(topTracks.items[1].images.small?.absoluteString, "https://images.com/artist-1-small.png")
                XCTAssertEqual(topTracks.items[1].images.medium?.absoluteString, "https://images.com/artist-1-medium.png")
                XCTAssertEqual(topTracks.items[1].images.large?.absoluteString, "https://images.com/artist-1-large.png")
                XCTAssertEqual(topTracks.items[1].images.extraLarge?.absoluteString, "https://images.com/artist-1-extralarge.png")

                XCTAssertEqual(topTracks.items[2].name, "Track-2")
                XCTAssertEqual(topTracks.items[2].duration, 0)
                XCTAssertEqual(topTracks.items[2].playcount, 300)
                XCTAssertEqual(topTracks.items[2].listeners, 13)
                XCTAssertEqual(topTracks.items[2].mbid, "")
                XCTAssertEqual(topTracks.items[2].url.absoluteString, "http://tracks.com/track-2")
                XCTAssertEqual(topTracks.items[2].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[2].artist.name, "Artist-2")
                XCTAssertEqual(topTracks.items[2].artist.mbid, "artist-2-mbid")
                XCTAssertEqual(topTracks.items[2].artist.url.absoluteString, "https://artists.com/artist-2")
                XCTAssertEqual(topTracks.items[2].images.small?.absoluteString, "https://images.com/artist-2-small.png")
                XCTAssertEqual(topTracks.items[2].images.medium?.absoluteString, "https://images.com/artist-2-medium.png")
                XCTAssertEqual(topTracks.items[2].images.large?.absoluteString, "https://images.com/artist-2-large.png")
                XCTAssertEqual(topTracks.items[2].images.extraLarge?.absoluteString, "https://images.com/artist-2-extralarge.png")

                XCTAssertEqual(topTracks.items[3].name, "Track-3")
                XCTAssertEqual(topTracks.items[3].duration, 0)
                XCTAssertEqual(topTracks.items[3].playcount, 400)
                XCTAssertEqual(topTracks.items[3].listeners, 14)
                XCTAssertEqual(topTracks.items[3].mbid, "")
                XCTAssertEqual(topTracks.items[3].url.absoluteString, "http://tracks.com/track-3")
                XCTAssertEqual(topTracks.items[3].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[3].artist.name, "Artist-3")
                XCTAssertEqual(topTracks.items[3].artist.mbid, "artist-3-mbid")
                XCTAssertEqual(topTracks.items[3].artist.url.absoluteString, "https://artists.com/artist-3")
                XCTAssertEqual(topTracks.items[3].images.small?.absoluteString, "https://images.com/artist-3-small.png")
                XCTAssertEqual(topTracks.items[3].images.medium?.absoluteString, "https://images.com/artist-3-medium.png")
                XCTAssertEqual(topTracks.items[3].images.large?.absoluteString, "https://images.com/artist-3-large.png")
                XCTAssertEqual(topTracks.items[3].images.extraLarge?.absoluteString, "https://images.com/artist-3-extralarge.png")

                XCTAssertEqual(topTracks.items[4].name, "Track-4")
                XCTAssertEqual(topTracks.items[4].duration, 0)
                XCTAssertEqual(topTracks.items[4].playcount, 500)
                XCTAssertEqual(topTracks.items[4].listeners, 15)
                XCTAssertEqual(topTracks.items[4].mbid, "")
                XCTAssertEqual(topTracks.items[4].url.absoluteString, "http://tracks.com/track-4")
                XCTAssertEqual(topTracks.items[4].streamable, .noStreamable)
                XCTAssertEqual(topTracks.items[4].artist.name, "Artist-4")
                XCTAssertEqual(topTracks.items[4].artist.mbid, "artist-4-mbid")
                XCTAssertEqual(topTracks.items[4].artist.url.absoluteString, "https://artists.com/artist-4")
                XCTAssertEqual(topTracks.items[4].images.small?.absoluteString, "https://images.com/artist-4-small.png")
                XCTAssertEqual(topTracks.items[4].images.medium?.absoluteString, "https://images.com/artist-4-medium.png")
                XCTAssertEqual(topTracks.items[4].images.large?.absoluteString, "https://images.com/artist-4-large.png")
                XCTAssertEqual(topTracks.items[4].images.extraLarge?.absoluteString, "https://images.com/artist-4-extralarge.png")

                XCTAssertEqual(topTracks.pagination.total, 35960258)
                XCTAssertEqual(topTracks.pagination.page, 1)
                XCTAssertEqual(topTracks.pagination.perPage, 5)
                XCTAssertEqual(topTracks.pagination.totalPages, 7192052)

            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertNil(apiClient.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=chart.gettoptracks&page=\(params.page)&limit=\(params.limit)")
        )
    }

    func test_getTopTracks_failure()  throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/geo.getTopTracksBadParams",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = ChartTopTracksParams()
        let expectation = expectation(description: "waiting for getTopTracks to fail")

        apiClient.data = fakeData
        // In real life, for some unknown reason, lastfm
        // returns a 200 even if country param is wrong.
        // But here we using a 400 bad request for testing porpuses.
        apiClient.response = Constants.RESPONSE_400_BAD_REQUEST

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success(_):
                XCTFail("Expected to fail, but it succedeed")
            case .failure(let error):
                switch (error) {

                case .LastFMServiceError(let errorType, let message):
                    XCTAssertEqual(errorType, .InvalidParameters)
                    XCTAssertEqual(message, "country param required")
                default:
                    XCTFail("Expected to be LastFMServiceErrorType.InvalidParameters")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getTopArtists

    func test_getTopArtists_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/chart.getTopArtists",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getTopArtists")
        let params = ChartTopArtistsParams(page: 1, limit: 5)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopArtists(params: params) { result in
            switch(result) {
            case .success(let topArtists):
                XCTAssertEqual(topArtists.pagination.page, 1)
                XCTAssertEqual(topArtists.pagination.perPage, 5)
                XCTAssertEqual(topArtists.pagination.total, 5552670)
                XCTAssertEqual(topArtists.pagination.totalPages, 1110534)

                XCTAssertEqual(topArtists.items.count, 5)
                XCTAssertEqual(topArtists.items[0].name, "The Weeknd")
                XCTAssertEqual(topArtists.items[0].listeners, 3555460)
                XCTAssertEqual(topArtists.items[0].mbid, "c8b03190-306c-4120-bb0b-6f2ebfc06ea9")
                XCTAssertEqual(topArtists.items[0].url.absoluteString, "https://www.last.fm/music/The+Weeknd")
                XCTAssertEqual(topArtists.items[0].streamable, false)

                XCTAssertEqual(
                    topArtists.items[0].images.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    topArtists.items[0].images.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    topArtists.items[0].images.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    topArtists.items[0].images.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    topArtists.items[0].images.mega!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
