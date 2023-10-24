import XCTest
@testable import LastFM

class ArtistModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: ArtistModule!
    private var apiClient = APIClientMock()

    override func setUpWithError() throws {
        instance = ArtistModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }

    // getTopTracks

    func test_corrected_getTopTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getCorrectedTopTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for successful corrected getTopTracks")

        let params = ArtistTopTracksParams(
            artist: "Cafe Tacuva",
            autocorrect: true,
            page: 1,
            limit: 5
        )

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<ArtistTopTrack>.self,
            from: fakeData
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
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
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.gettoptracks&artist=\(params.artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&autocorrect=\(params.autocorrect ? "1" : "0")&limit=\(params.limit)&page=\(params.page)")
        )
    }

    func test_non_corrected_getTopTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getNonCorrectedTopTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for successful corrected getTopTracks")

        let params = ArtistTopTracksParams(
            artist: "Cafe Tacuva",
            autocorrect: true,
            page: 1,
            limit: 5
        )

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<ArtistTopTrack>.self,
            from: fakeData
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
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
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.gettoptracks&artist=\(params.artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&autocorrect=\(params.autocorrect ? "1" : "0")&limit=\(params.limit)&page=\(params.page)")
        )
    }

    func test_getTopTracks_failure()  throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getTopTracksBadParams",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = ArtistTopTracksParams()
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
                    XCTAssertEqual(message, "The artist you supplied could not be found")
                default:
                    XCTFail("Expected to be LastFMServiceErrorType.InvalidParameters")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getSimilar

    func test_getSimilar_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getSimilar",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectaction = expectation(description: "waiting for artist.getSimilar")

        let params = ArtistSimilarParams(
            artist: "Queens Of The Stone Age",
            mbid: nil,
            autocorrect: false,
            limit: 5
        )

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getSimilar(params: params) { result in
            switch (result) {
            case .success(let similarArtist):
                XCTAssertEqual(similarArtist.items.count, 5)
                XCTAssertEqual(similarArtist.items[1].name, "Desert Sessions")
                XCTAssertEqual(similarArtist.items[1].mbid, "7a2e6b55-f149-4e74-be6a-30a1b1a387bb")
                XCTAssertEqual(similarArtist.items[1].match, 0.620856)

                XCTAssertEqual(
                    similarArtist.items[1].url.absoluteString,
                    "https://www.last.fm/music/Desert+Sessions"
                )

                XCTAssertEqual(
                    similarArtist.items[1].images.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].images.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].images.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].images.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].images.mega!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(similarArtist.items[0].streamable, false)
            case .failure(let error):
                XCTFail(
                    "Expected to succeed, but it failed with error: \(error.localizedDescription)"
                )
            }

            expectaction.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertNil(apiClient.getCalls[0].headers)

//        XCTAssertTrue(
//            Util.areSameURL(
//                apiClient.getCalls[0].url.absoluteString,
//                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.gettoptracks&artist=\(params.artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&autocorrect=\(params.autocorrect ? "1" : "0")&limit=\(params.limit)&page=\(params.page)")
//        )
    }
}
