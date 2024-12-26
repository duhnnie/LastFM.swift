import XCTest
@testable import LastFM

class LibraryModuleTests: XCTestCase {

    private static let lastFM = LastFM(
        apiKey: Constants.API_KEY,
        apiSecret: Constants.API_SECRET
    )

    private var instance: LibraryModule!
    private var apiClientMock = APIClientMock()

    override func setUpWithError() throws {
        instance = LibraryModule(
            parent: Self.lastFM,
            secure: true,
            requester: RequestUtils(apiClient: apiClientMock)
        )
    }

    override func tearDownWithError() throws {
        apiClientMock.clearMock()
    }

    private func validateLibraryGetArtists(_ libraryArtist: CollectionPage<LibraryArtist>) {
        XCTAssertEqual(libraryArtist.pagination.totalPages, 2850)
        XCTAssertEqual(libraryArtist.pagination.page, 1)
        XCTAssertEqual(libraryArtist.pagination.total, 14248)
        XCTAssertEqual(libraryArtist.pagination.perPage, 5)

        XCTAssertEqual(libraryArtist.items[0].tagcount, 0)

        XCTAssertEqual(
            libraryArtist.items[0].image.small!.absoluteString,
            "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
        )

        XCTAssertEqual(
            libraryArtist.items[0].image.medium!.absoluteString,
            "https://lastfm.freetls.fastly.net/i/u/64s/2a96cbd8b46e442fc41c2b86b821562f.png"
        )

        XCTAssertEqual(
            libraryArtist.items[0].image.large!.absoluteString,
            "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"
        )

        XCTAssertEqual(
            libraryArtist.items[0].image.extraLarge!.absoluteString,
            "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
        )

        XCTAssertEqual(
            libraryArtist.items[0].image.mega!.absoluteString,
            "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
        )

        XCTAssertEqual(libraryArtist.items[0].mbid, "67f66c07-6e61-4026-ade5-7e782fad3a5d")

        XCTAssertEqual(
            libraryArtist.items[0].url.absoluteString,
            "https://www.last.fm/music/Foo+Fighters"
        )

        XCTAssertEqual(libraryArtist.items[0].playcount, 3690)
        XCTAssertEqual(libraryArtist.items[0].name, "Foo Fighters")
        XCTAssertEqual(libraryArtist.items[0].streamable, false)
    }

    // getLovedTracks

    func test_getArtists_success() async throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/library.getArtists", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = SearchParams(term: "someuser", limit: 5, page: 1)

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        let libraryArtists = try await instance.getArtists(params: params)

        validateLibraryGetArtists(libraryArtists)

        XCTAssertEqual(apiClientMock.asyncGetCalls.count, 1)
        XCTAssertEqual(apiClientMock.asyncGetCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClientMock.asyncGetCalls[0].url.absoluteString,
                "https://ws.audioscrobbler.com/2.0?method=library.getartists&user=someuser&limit=5&page=1&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

    func test_getArtists_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/library.getArtists", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = SearchParams(term: "someuser", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for getLovedTracks")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getArtists(params: params) { result in
            switch(result) {
            case .success(let libraryArtists):
                self.validateLibraryGetArtists(libraryArtists)
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
                "https://ws.audioscrobbler.com/2.0?method=library.getartists&user=someuser&limit=5&page=1&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

}
