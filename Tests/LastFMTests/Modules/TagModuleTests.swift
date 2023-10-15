import XCTest
@testable import LastFM

class TagModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: TagModule!
    private var apiClient = APICLientMock()

    override func setUpWithError() throws {
        instance = TagModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }

    // getTropTracks

    func test_getTopTracks_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/tag.getTopTracks", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let expectedEntity = try JSONDecoder().decode(CollectionPage<TagTopTrack>.self, from: fakeData)
        let params = TagTopTracksParams(tag: "Pop punk", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for getTopTracks")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let list):
                XCTAssertEqual(list, expectedEntity)
            case .failure(let error):
                XCTFail("Expected to fail. Got \"\(error.localizedDescription)\" error instead")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertNil(apiClient.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=tag.gettoptracks&api_key=\(Constants.API_KEY)&limit=\(params.limit)&format=json&tag=\(params.tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&page=1"
            )
        )
    }

    func test_getTopTracks_failure() throws {
        let params = TagTopTracksParams(tag: "Some Tag", limit: 35, page: 5)

        apiClient.error = RuntimeError("Some error")

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }

}
