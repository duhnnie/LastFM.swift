import XCTest
@testable import LastFM

class UserTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: UserModule!
    private var apiClientMock = APIClientMock()

    override func setUpWithError() throws {
        instance = UserModule(
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClientMock)
        )
    }

    override func tearDownWithError() throws {
        apiClientMock.clearMock()
    }

    func test_invalidAPIKey() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/errorInvalidAPIKey",
            withExtension: "json"
        )!

        let params = UserTopTracksParams(user: "andrea")
        let expectation = expectation(description: "waiting for request with invalid api key")

        apiClientMock.data = try Data(contentsOf: jsonURL)
        apiClientMock.response = Constants.RESPONSE_403_FORBIDDEN

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(let error):
                switch (error) {

                case .LastFMServiceError(let lastfmErrorType, let message):
                    XCTAssertEqual(lastfmErrorType, .InvalidAPIKey)
                    XCTAssertEqual(message, "Invalid API key - You must be granted a valid key by last.fm")
                default:
                    XCTFail("Expected to be a LastFMError.InvalidAPIKey, but we got \(error) instead")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func test_withInvalidPageNumber() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/errorInvalidParameters",
            withExtension: "json"
        )!

        let params = RecentTracksParams(user: "stephanie")
        let expectation = expectation(description: "waiting for invalid parameters response")

        apiClientMock.data = try Data(contentsOf: jsonURL)
        apiClientMock.response = Constants.RESPONSE_400_BAD_REQUEST

        instance.getRecentTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeeded instead")
            case .failure(let error):
                switch(error) {
                case .LastFMServiceError(let lastfmErrorType, let message):
                    XCTAssertEqual(lastfmErrorType, .InvalidParameters)
                    XCTAssertEqual(message, "page param out of bounds (1-1000000)")
                default:
                    XCTFail("Expected to be a LastFMError.InvaluParameters error, but we got \(error)")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getRecentTracks

    func test_getRecentTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getRecentTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for getRecentTracks")

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<RecentTrack>.self,
            from: fakeData
        )

        let params = RecentTracksParams(user: "someUser", limit: 5, page: 1)

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getRecentTracks(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(_):
                XCTFail("Expected to succeed but it failed")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=\(params.user)&extended=0&limit=\(params.limit)&api_key=\(Constants.API_KEY)&format=json&page=\(params.page)"
            )
        )
    }

    func test_getRecentTracks_failure() throws {
        let params = RecentTracksParams(user: "pepito")
        let expectation = expectation(description: "waiting for getRecentTracks")

        apiClientMock.error = RuntimeError("fake error")

        instance.getRecentTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("It was expected to fail, but it succeeded")
            case .failure(_):
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getExtendedRecentTracks

    func test_getExtendedRecentTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getExtendedRecentTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for getExtendedRecentTracks")

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<ExtendedRecentTrack>.self,
            from: fakeData
        )

        let params = RecentTracksParams(
            user: "Pepito",
            limit: 5,
            page: 1,
            from: 23454646,
            to: 345646343
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getExtendedRecentTracks(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(_):
                XCTFail("It was expected to fail, but it succeeded instead")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=\(params.user)&extended=1&limit=\(params.limit)&api_key=\(Constants.API_KEY)&format=json&page=\(params.page)&from=\(params.from!)&to=\(params.to!)"
            )
        )
    }

    func test_getExtendedRecentTracks_failure() throws {
        let expectation = expectation(description: "waiting for getExtendedRecentTracks")
        let params = RecentTracksParams(user: "trent")

        apiClientMock.error = RuntimeError("Beautiful error")

        instance.getExtendedRecentTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("It was expected to fail, but it succeeded instead")
            case .failure(_):
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getTopTracks

    func test_getTopTracks_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getTopTracks",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<UserTopTrack>.self,
            from: fakeData
        )

        let params = UserTopTracksParams(
            user: "pepito",
            period: .last180days,
            limit: 34,
            page: 234
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        let expectation = expectation(description: "waiting for succesful getTopTracks")

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success(let entity):
                XCTAssertEqual(expectedEntity, entity)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClientMock.postCalls.count, 0)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertNil(apiClientMock.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=user.gettoptracks&user=\(params.user)&limit=\(params.limit)&page=\(params.page)&period=\(params.period.rawValue)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
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
            case .failure(LastFMError.OtherError(let error)):
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

    // getWeeklyTrackChart

    func test_getWeeklyTrackChart_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getWeeklyTrackChart",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = UserWeeklyChartParams(user: "user", from: 123412, to: 53452)

        let expectedEntity = try JSONDecoder().decode(
            CollectionList<UserWeeklyTrackChart>.self,
            from: fakeData
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        let expectation = expectation(description: "Waiting for getWeeklyTrackChart")

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(apiClientMock.postCalls.count, 0)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=user.getweeklytrackchart&user=\(params.user)&from=\(params.from)&to=\(params.to)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    func test_getWeeklyTrackChart_failure() throws {
        let params = UserWeeklyChartParams(user: "asdf", from: 3452, to: 56433)
        let expectation = expectation(description: "Waiting for getWeeklyTrackChart")
        apiClientMock.error = RuntimeError("Fake error")

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(LastFMError.OtherError(let error)):
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

    // getLovedTracks

    func test_getLovedTracks_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/user.getLovedTracks", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = LovedTracksParams(user: "someUser", limit: 5, page: 12)
        let expectation = expectation(description: "waiting for getLovedTracks")

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<LovedTrack>.self,
            from: fakeData
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getLovedTracks(params: params) { result in
            switch(result) {
            case .success(let lovedTracks):
                XCTAssertEqual(lovedTracks, expectedEntity)
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
                "http://ws.audioscrobbler.com/2.0?method=user.getlovedtracks&user=\(params.user)&limit=\(params.limit)&page=\(params.page)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    func test_getLovedTracks_failure() throws {
        let params = LovedTracksParams(user: "Copo", limit: 345, page: 345)
        let expectation = expectation(description: "waiting for getLovedTracks")

        apiClientMock.error = RuntimeError("Any error")

        instance.getLovedTracks(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeed.")
            case .failure(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getTopArtists

    func test_getTopArtists_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/user.getTopArtists", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = UserTopArtistsParams(user: "someUser", limit: 5, page: 12)
        let expectation = expectation(description: "waiting for getTopArtists")

        let expectedEntity = try JSONDecoder().decode(
            CollectionPage<UserTopArtist>.self,
            from: fakeData
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getTopArtists(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
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
                "http://ws.audioscrobbler.com/2.0?method=user.gettopartists&user=\(params.user)&period=\(params.period)&limit=\(params.limit)&page=\(params.page)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    func test_getTopArtists_failure() throws {
        let params = UserTopArtistsParams(user: "Copo", limit: 345, page: 345)
        let expectation = expectation(description: "waiting for getLovedTracks")

        apiClientMock.error = RuntimeError("Any error")

        instance.getTopArtists(params: params) { result in
            switch(result) {
            case .success(_):
                XCTFail("Expected to fail, but it succeed.")
            case .failure(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    // getWeeklyArtistChart

    func test_getWeeklyArtistChart_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/user.getWeeklyArtistChart",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = UserWeeklyChartParams(user: "user", from: 123412, to: 53452)

        let expectedEntity = try JSONDecoder().decode(
            CollectionList<UserWeeklyArtistChart>.self,
            from: fakeData
        )

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        let expectation = expectation(description: "Waiting for getWeeklyArtistChart")

        instance.getWeeklyArtistChart(params: params) { result in
            switch (result) {
            case .success(let entity):
                XCTAssertEqual(entity, expectedEntity)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(apiClientMock.postCalls.count, 0)
        XCTAssertEqual(apiClientMock.getCalls.count, 1)
        XCTAssertEqual(apiClientMock.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?method=user.getweeklyartistchart&user=\(params.user)&from=\(params.from)&to=\(params.to)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    // getTopAlbums

    func test_getTopAlbums_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/user.getTopAlbums", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = UserTopAlbumsParams(user: "someUser", limit: 5, page: 12)
        let expectation = expectation(description: "waiting for getTopAlbums")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getTopAlbums(params: params) { result in
            switch(result) {
            case .success(let entity):
                XCTAssertEqual(entity.items.count, 5)
                XCTAssertEqual(entity.items[0].artist.name, "The Ataris")

                XCTAssertEqual(
                    entity.items[0].artist.mbid,
                    "57805d77-f947-4851-b7fb-78baad154451"
                )

                XCTAssertEqual(
                    entity.items[0].artist.url.absoluteString,
                    "https://www.last.fm/music/The+Ataris"
                )

                XCTAssertEqual(
                    entity.items[0].images.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/baad825eec21da267b92599dc9ed2f66.jpg"
                )

                XCTAssertEqual(
                    entity.items[0].images.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/baad825eec21da267b92599dc9ed2f66.jpg"
                )

                XCTAssertEqual(
                    entity.items[0].images.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/baad825eec21da267b92599dc9ed2f66.jpg"
                )

                XCTAssertEqual(
                    entity.items[0].images.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/baad825eec21da267b92599dc9ed2f66.jpg"
                )

                XCTAssertNil(entity.items[0].images.mega)
                XCTAssertEqual(entity.pagination.page, 1)
                XCTAssertEqual(entity.pagination.perPage, 5)
                XCTAssertEqual(entity.pagination.total, 30448)
                XCTAssertEqual(entity.pagination.totalPages, 6090)
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
                "http://ws.audioscrobbler.com/2.0?method=user.gettopalbums&user=\(params.user)&period=\(params.period)&limit=\(params.limit)&page=\(params.page)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }
}
