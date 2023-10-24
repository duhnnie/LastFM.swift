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
            instance: Self.lastFM,
            requester: RequestUtils(apiClient: apiClientMock)
        )
    }

    override func tearDownWithError() throws {
        apiClientMock.clearMock()
    }

    // getLovedTracks

    func test_getArtists_success() throws {
        let fakeDataURL = Bundle.module.url(forResource: "Resources/library.getArtists", withExtension: "json")!
        let fakeData = try Data(contentsOf: fakeDataURL)
        let params = LibraryArtistsParams(user: "duhnnie", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for getLovedTracks")

        apiClientMock.data = fakeData
        apiClientMock.response = Constants.RESPONSE_200_OK

        instance.getArtists(params: params) { result in
            switch(result) {
            case .success(let lovedTracks):
                XCTAssertEqual(lovedTracks.pagination.totalPages, 2850)
                XCTAssertEqual(lovedTracks.pagination.page, 1)
                XCTAssertEqual(lovedTracks.pagination.total, 14248)
                XCTAssertEqual(lovedTracks.pagination.perPage, 5)

                XCTAssertEqual(lovedTracks.items[0].tagcount, 0)

                XCTAssertEqual(
                    lovedTracks.items[0].images.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    lovedTracks.items[0].images.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    lovedTracks.items[0].images.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    lovedTracks.items[0].images.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    lovedTracks.items[0].images.mega!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(lovedTracks.items[0].mbid, "67f66c07-6e61-4026-ade5-7e782fad3a5d")

                XCTAssertEqual(
                    lovedTracks.items[0].url.absoluteString,
                    "https://www.last.fm/music/Foo+Fighters"
                )

                XCTAssertEqual(lovedTracks.items[0].playcount, 3690)
                XCTAssertEqual(lovedTracks.items[0].name, "Foo Fighters")
                XCTAssertEqual(lovedTracks.items[0].streamable, false)
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
                "http://ws.audioscrobbler.com/2.0?method=library.getartists&user=\(params.user)&limit=\(params.limit)&page=\(params.page)&api_key=\(Constants.API_KEY)&format=json"
            )
        )
    }

}
