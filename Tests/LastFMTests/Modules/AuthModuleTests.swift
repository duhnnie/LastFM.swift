import XCTest
@testable import LastFM

class AuthModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: AuthModule!
    private var apiClient = APIClientMock()

    override func setUpWithError() throws {
        instance = AuthModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClient)
        )
    }

    override func tearDownWithError() throws {
        apiClient.clearMock()
    }

    func test_getSession_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/auth.getSession",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getSession()")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.getSession(token: "myToken") { result in
            expectation.fulfill()

            switch (result) {
            case .success(let session):
                XCTAssertEqual(session.name, "pepiro")
                XCTAssertEqual(session.key, "1234567890")
                XCTAssertEqual(session.subscriber, false)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed. Error: \(error.localizedDescription)")
            }
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?api_key=someAPIKey&format=json&method=auth.getsession&token=myToken&api_sig=a0a73c6e4fba81fb1fb1be8e92481634"
            )
        )
    }

}
