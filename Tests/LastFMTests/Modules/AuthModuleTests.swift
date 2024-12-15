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
            parent: Self.lastFM,
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
                "https://ws.audioscrobbler.com/2.0?api_key=someAPIKey&format=json&method=auth.getsession&token=myToken&api_sig=a0a73c6e4fba81fb1fb1be8e92481634"
            )
        )
    }

    func test_getToken_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/auth.getToken",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getToken()")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.getToken { result in
            expectation.fulfill()

            switch (result) {
            case .success(let token):
                XCTAssertEqual(token, "0987654321")
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
                "https://ws.audioscrobbler.com/2.0?format=json&api_sig=122ce70950973a4b1f1d8c59030fa108&method=auth.gettoken&api_key=someAPIKey"
            )
        )
    }

    func test_getMobileSession_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/auth.getSession",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "Waiting for getMobileSession()")

        let expectedPayload = "password=436tggdsgh&api_sig=fb79d4df16117ad14c423bea23f3d107&username=pepiro&api_key=someAPIKey&method=auth.getmobilesession"

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        try instance.getMobileSession(username: "pepiro", password: "436tggdsgh") { result in
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
        XCTAssertEqual(apiClient.postCalls.count, 1)
        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payload = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "https://domain.com/?\(payload)",
                "https://domain.com/?\(expectedPayload)"
            )
        )

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.postCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?format=json"
            )
        )
    }

}
