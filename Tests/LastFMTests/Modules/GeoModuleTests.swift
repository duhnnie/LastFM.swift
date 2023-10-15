import XCTest
@testable import LastFM

class GeoModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: GeoModule!
    private var apiClient = APICLientMock()

    override func setUpWithError() throws {
        instance = GeoModule(
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
            forResource: "Resources/geo.getTopTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for successful getTopTracks")

        let params = GeoTopTracksParams(
            country: "Bolivia",
            location: "somelocation",
            limit: 5,
            page: 1
        )

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<GeoTopTrack>.self,
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
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=geo.gettoptracks&country=\(params.country)&location=\(params.location!)&limit=\(params.limit)&page=\(params.page)")
        )
    }

    func test_getTopTracks_failure()  throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/geo.getTopTracksBadParams",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = GeoTopTracksParams(country: "bo")
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
}
