import XCTest
@testable import swiftfm

class UserTests: XCTestCase {

    private static let apiKey = "someAPIkey"
    private static let apiSecret = "someAPIsecret"
    private static let swiftFM = SwiftFM(apiKey: apiKey, apiSecret: apiSecret)

    private static let fakeResponse = HTTPURLResponse(
        url: URL(string: "http://dummyResponse.com")!,
        statusCode: 200,
        httpVersion: "1.0",
        headerFields: nil
    )

    private var instance: User!
    private var apiClientMock = APICLientMock()

    override func setUpWithError() throws {
        instance = User(
            instance: Self.swiftFM,
            requester: RequestUtils(apiClient: apiClientMock)
        )
    }

    override func tearDownWithError() throws {
        apiClientMock.clearMock()
    }

    // getTopTracks

    func test_getTopTracks_success() throws {
        let topTracksItemsJSON = UserTopTracksTestUtils.list.map { dataset in
            return UserTopTracksTestUtils.generateJSON(dataset: dataset)
        }.joined(separator: ",")

        let fakeData = CollectionPageTestUtils.generateJSON(
            items: "[\(topTracksItemsJSON)]",
            totalPages: "10",
            page: "1",
            perPage: "4",
            total: "40"
        )

        let expectedTopTracks = try JSONDecoder().decode(
            CollectionPage<UserTopTrack>.self,
            from: fakeData
        )

        let user = "Pepito"
        let period = UserTopTracksParams.Period.last180days
        let limit: UInt = 34
        let page: UInt = 21

        let params = UserTopTracksParams(
            user: user,
            period: period,
            limit: limit,
            page: page
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Self.fakeResponse

        let expectation = expectation(description: "waiting for succesful getTopTracks")

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success(let userTopTracks):
                XCTAssertEqual(expectedTopTracks, userTopTracks)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.postCalls.count, 0)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)

        XCTAssertEqual(
            apiClientMock.getCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?method=user.getTopTracks&user=\(user)&limit=\(limit)&page=\(page)&period=\(period.rawValue)&api_key=\(Self.apiKey)&format=json"
        )

        XCTAssertNil(apiClientMock.getCalls[0].headers)
    }

    func test_getTopTracks_failure() throws {
        let params = UserTopTracksParams(
            user: "user",
            period: .last180days,
            limit: 10,
            page: 2
        )

        let error = RuntimeError("Fake error")
        apiClientMock.error = error

        let expectation = expectation(description: "waiting for failure getTopTracks")

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(ServiceError.OtherError(let error)):
                XCTAssert(error is RuntimeError)
                XCTAssertEqual(error.localizedDescription, "Fake error")
            default:
                XCTFail("Expected to be a Runtime \"Fake error\" error")
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func test_invalidAPIKey() throws {
        // To be implmented
    }

    // getWeeklyTrackChart

    func test_getWeeklyTrackChart_success() throws {
        let weeklyChartTracksJSON = UserWeeklyTrackChartTestUtils.list.map { dataset in
            return UserWeeklyTrackChartTestUtils.generateJSON(dataset: dataset)
        }.joined(separator: ",")

        let fakeData = CollectionListTestUtils.generateJSON(
            items: "[\(weeklyChartTracksJSON)]"
        ).data(using: .utf8)!

        let expectedEntity = try JSONDecoder().decode(
            CollectionList<UserWeeklyChartTrack>.self,
            from: fakeData
        )

        let user = "Pepito"
        let from: UInt = 1665622629
        let to: UInt = 1697158629

        let params = UserWeeklyTrackChartParams(user: user, from: from, to: to)

        apiClientMock.data = fakeData
        apiClientMock.response = Self.fakeResponse

        let expectation = expectation(description: "Waiting for getWeeklyTrackChart")

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success(let weeklytrackchart):
                XCTAssertEqual(weeklytrackchart, expectedEntity)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(apiClientMock.postCalls.count, 0)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)

        XCTAssertEqual(
            apiClientMock.getCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?method=user.getWeeklyTrackChart&user=\(user)&from=\(from)&to=\(to)&api_key=\(Self.apiKey)&format=json"
        )

        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)
    }

    func test_getWeeklyTrackChart_failure() throws {
        let weeklyChartTracksJSON = UserWeeklyTrackChartTestUtils.list.map { dataset in
            return UserWeeklyTrackChartTestUtils.generateJSON(dataset: dataset)
        }.joined(separator: ",")

        let fakeData = CollectionListTestUtils.generateJSON(
            items: "[\(weeklyChartTracksJSON)]"
        ).data(using: .utf8)!

        let params = UserWeeklyTrackChartParams(user: "asdf", from: 3452, to: 56433)
        let expectation = expectation(description: "Waiting for getWeeklyTrackChart")
        apiClientMock.error = RuntimeError("Fake error")

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(ServiceError.OtherError(let error)):
                XCTAssert(error is RuntimeError)
                XCTAssertEqual(error.localizedDescription, "Fake error")
            default:
                XCTFail("Expected to be a Runtime \"Fake error\" error")
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
