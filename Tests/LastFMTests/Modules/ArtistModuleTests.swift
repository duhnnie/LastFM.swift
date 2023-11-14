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
            parent: Self.lastFM,
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

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let topTracks):
                XCTAssertEqual(topTracks.pagination.total, 38)
                XCTAssertEqual(topTracks.pagination.totalPages, 16)
                XCTAssertEqual(topTracks.pagination.perPage, 2)
                XCTAssertEqual(topTracks.pagination.page, 1)

                XCTAssertEqual(topTracks.items[0].name, "Track 0")
                XCTAssertEqual(topTracks.items[0].playcount, 23400)
                XCTAssertEqual(topTracks.items[0].listeners, 30)
                XCTAssertEqual(topTracks.items[0].mbid, "track-0-mbid")
                XCTAssertEqual(topTracks.items[0].url.absoluteString, "https://tracks.com/track-0")
                XCTAssertEqual(topTracks.items[0].streamable, false)
                XCTAssertEqual(topTracks.items[0].artist.name, "Some Artist")
                XCTAssertEqual(topTracks.items[0].artist.mbid, "some-artist-mbid")
                XCTAssertEqual(topTracks.items[0].artist.url.absoluteString, "https://artists.com/some-artist")
                XCTAssertEqual(topTracks.items[0].image.small?.absoluteString, "https://images.com/track-0-s.png")
                XCTAssertEqual(topTracks.items[0].image.medium?.absoluteString, "https://images.com/track-0-m.png")
                XCTAssertEqual(topTracks.items[0].image.large?.absoluteString, "https://images.com/track-0-l.png")
                XCTAssertEqual(topTracks.items[0].image.extraLarge?.absoluteString, "https://images.com/track-0-xl.png")

                XCTAssertEqual(topTracks.items[0].rank, 1)
                XCTAssertEqual(topTracks.items[1].name, "Track 1")
                XCTAssertEqual(topTracks.items[1].playcount, 23410)
                XCTAssertEqual(topTracks.items[1].listeners, 31)
                XCTAssertEqual(topTracks.items[1].mbid, "track-1-mbid")
                XCTAssertEqual(topTracks.items[1].url.absoluteString, "https://tracks.com/track-1")
                XCTAssertEqual(topTracks.items[1].streamable, false)
                XCTAssertEqual(topTracks.items[1].artist.name, "Some Artist")
                XCTAssertEqual(topTracks.items[1].artist.mbid, "some-artist-mbid")
                XCTAssertEqual(topTracks.items[1].artist.url.absoluteString, "https://artists.com/some-artist")
                XCTAssertEqual(topTracks.items[1].image.small?.absoluteString, "https://images.com/track-1-s.png")
                XCTAssertEqual(topTracks.items[1].image.medium?.absoluteString, "https://images.com/track-1-m.png")
                XCTAssertEqual(topTracks.items[1].image.large?.absoluteString, "https://images.com/track-1-l.png")
                XCTAssertEqual(topTracks.items[1].image.extraLarge?.absoluteString, "https://images.com/track-1-xl.png")
                XCTAssertEqual(topTracks.items[1].rank, 2)
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

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopTracks(params: params) { result in
            switch(result) {
            case .success(let topTracks):
                XCTAssertEqual(topTracks.pagination.total, 38)
                XCTAssertEqual(topTracks.pagination.totalPages, 16)
                XCTAssertEqual(topTracks.pagination.perPage, 2)
                XCTAssertEqual(topTracks.pagination.page, 1)

                XCTAssertEqual(topTracks.items[0].name, "Track 0")
                XCTAssertEqual(topTracks.items[0].playcount, 23400)
                XCTAssertEqual(topTracks.items[0].listeners, 30)
                XCTAssertNil(topTracks.items[0].mbid)
                XCTAssertEqual(topTracks.items[0].url.absoluteString, "https://tracks.com/track-0")
                XCTAssertEqual(topTracks.items[0].streamable, false)
                XCTAssertEqual(topTracks.items[0].artist.name, "Some Artist")
                XCTAssertNil(topTracks.items[0].artist.mbid)
                XCTAssertEqual(topTracks.items[0].artist.url.absoluteString, "https://artists.com/some-artist")
                XCTAssertEqual(topTracks.items[0].image.small?.absoluteString, "https://images.com/track-0-s.png")
                XCTAssertEqual(topTracks.items[0].image.medium?.absoluteString, "https://images.com/track-0-m.png")
                XCTAssertEqual(topTracks.items[0].image.large?.absoluteString, "https://images.com/track-0-l.png")
                XCTAssertEqual(topTracks.items[0].image.extraLarge?.absoluteString, "https://images.com/track-0-xl.png")

                XCTAssertEqual(topTracks.items[0].rank, 1)
                XCTAssertEqual(topTracks.items[1].name, "Track 1")
                XCTAssertEqual(topTracks.items[1].playcount, 23410)
                XCTAssertEqual(topTracks.items[1].listeners, 31)
                XCTAssertNil(topTracks.items[1].mbid)
                XCTAssertEqual(topTracks.items[1].url.absoluteString, "https://tracks.com/track-1")
                XCTAssertEqual(topTracks.items[1].streamable, false)
                XCTAssertEqual(topTracks.items[1].artist.name, "Some Artist")
                XCTAssertNil(topTracks.items[1].artist.mbid)
                XCTAssertEqual(topTracks.items[1].artist.url.absoluteString, "https://artists.com/some-artist")
                XCTAssertEqual(topTracks.items[1].image.small?.absoluteString, "https://images.com/track-1-s.png")
                XCTAssertEqual(topTracks.items[1].image.medium?.absoluteString, "https://images.com/track-1-m.png")
                XCTAssertEqual(topTracks.items[1].image.large?.absoluteString, "https://images.com/track-1-l.png")
                XCTAssertEqual(topTracks.items[1].image.extraLarge?.absoluteString, "https://images.com/track-1-xl.png")
                XCTAssertEqual(topTracks.items[1].rank, 2)
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
                    similarArtist.items[1].image.small!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].image.medium!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].image.large!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].image.extraLarge!.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png"
                )

                XCTAssertEqual(
                    similarArtist.items[1].image.mega!.absoluteString,
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

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.getsimilar&artist=\(params.artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&autocorrect=\(params.autocorrect ? "1" : "0")&limit=\(params.limit)")
        )
    }

    // search

    func test_search() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.search",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let params = SearchParams(term: "neuronas", limit: 5, page: 1)
        let expectation = expectation(description: "waiting for artist search results")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.search(params: params) { result in
            switch(result) {
            case .success(let searchResults):
                XCTAssertEqual(searchResults.items.count, 5)
                XCTAssertEqual(searchResults.items[3].name, "Las Últimas Neuronas")
                XCTAssertEqual(searchResults.items[3].listeners, 1)
                XCTAssertEqual(searchResults.items[3].mbid, "")

                XCTAssertEqual(
                    searchResults.items[3].url.absoluteString,
                    "https://www.last.fm/music/Las+%C3%9Altimas+Neuronas"
                )

                XCTAssertEqual(searchResults.items[3].streamable, false)
                XCTAssertNil(searchResults.items[3].image.small)
                XCTAssertNil(searchResults.items[3].image.medium)
                XCTAssertNil(searchResults.items[3].image.large)
                XCTAssertNil(searchResults.items[3].image.extraLarge)
                XCTAssertNil(searchResults.items[3].image.mega)

                XCTAssertEqual(searchResults.pagination.startPage, 1)
                XCTAssertEqual(searchResults.pagination.totalResults, 31)
                XCTAssertEqual(searchResults.pagination.startIndex, 0)
                XCTAssertEqual(searchResults.pagination.itemsPerPage, 5)

            case.failure(let error):
                XCTFail("It was supposed to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertNil(apiClient.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.search&artist=neuronas&limit=\(params.limit)&page=\(params.page)")
        )
    }

    func test_getTopAlbums_success() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getTopAlbums",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)
        let expectation = expectation(description: "waiting for artists' top albums")
        let params = ArtistTopAlbumsParams(artist: "No Use For a Name", limit: 5)

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getTopAlbums(params: params) { result in
            switch(result) {
            case .success(let topAlbums):
                XCTAssertEqual(topAlbums.items.count, 5)
                XCTAssertEqual(topAlbums.pagination.page, 1)
                XCTAssertEqual(topAlbums.pagination.perPage, 5)
                XCTAssertEqual(topAlbums.pagination.totalPages, 1049)
                XCTAssertEqual(topAlbums.pagination.total, 5244)

                XCTAssertEqual(topAlbums.pagination.total, 5244)
                XCTAssertEqual(topAlbums.items[1].name, "More Betterness!")
                XCTAssertEqual(topAlbums.items[1].playcount, 1235966)

                XCTAssertEqual(
                    topAlbums.items[1].mbid,
                    "272591da-1dd6-4713-8e01-7d180861129c"
                )

                XCTAssertEqual(
                    topAlbums.items[1].url.absoluteString,
                    "https://www.last.fm/music/No+Use+for+a+Name/More+Betterness%21"
                )

                XCTAssertEqual(topAlbums.items[1].artist.name, "No Use for a Name")

                XCTAssertEqual(
                    topAlbums.items[1].artist.mbid,
                    "d7bd0fad-2f06-4936-89ad-60c5b6ada3c1"
                )

                XCTAssertEqual(
                    topAlbums.items[1].artist.url.absoluteString,
                    "https://www.last.fm/music/No+Use+for+a+Name"
                )

                XCTAssertEqual(
                    topAlbums.items[1].image.small?.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/34s/a3ee30ac1c7c4176be8757ab8b8be5ce.png"
                )

                XCTAssertEqual(
                    topAlbums.items[1].image.medium?.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/64s/a3ee30ac1c7c4176be8757ab8b8be5ce.png"
                )

                XCTAssertEqual(
                    topAlbums.items[1].image.large?.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/174s/a3ee30ac1c7c4176be8757ab8b8be5ce.png"
                )

                XCTAssertEqual(
                    topAlbums.items[1].image.extraLarge?.absoluteString,
                    "https://lastfm.freetls.fastly.net/i/u/300x300/a3ee30ac1c7c4176be8757ab8b8be5ce.png"
                )

                XCTAssertNil(topAlbums.items[1].image.mega)
            case .failure(let error):
                XCTFail("Expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertNil(apiClient.getCalls[0].headers)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0/?api_key=\(Constants.API_KEY)&format=json&method=artist.gettopalbums&artist=\(params.artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&autocorrect=\(params.autocorrect ? "1" : "0")&limit=\(params.limit)&page=\(params.page)")
        )
    }

    func test_getInfo_with_username() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = ArtistInfoParams(
            term: "Some Artist",
            criteria: .artist,
            lang: "en",
            username: "pepiro"
        )

        let expectation = expectation(description: "waiting for getInfo")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let artistInfo):
                XCTAssertEqual(artistInfo.name, "Some Artist")
                XCTAssertEqual(artistInfo.mbid, "some-mbid")
                XCTAssertEqual(artistInfo.url.absoluteString, "https://someartist.com")

                XCTAssertEqual(
                    artistInfo.image.small?.absoluteString,
                    "https://images.com/s.png"
                )

                XCTAssertEqual(
                    artistInfo.image.medium?.absoluteString,
                    "https://images.com/m.png"
                )

                XCTAssertEqual(
                    artistInfo.image.large?.absoluteString,
                    "https://images.com/l.png"
                )

                XCTAssertEqual(
                    artistInfo.image.extraLarge?.absoluteString,
                    "https://images.com/e.png"
                )

                XCTAssertEqual(
                    artistInfo.image.mega?.absoluteString,
                    "https://images.com/mg.png"
                )

                XCTAssertEqual(artistInfo.streamable, false)
                XCTAssertEqual(artistInfo.onTour, true)
                XCTAssertEqual(artistInfo.stats.listeners, 5065436)
                XCTAssertEqual(artistInfo.stats.playcount, 258631203)
                XCTAssertNotNil(artistInfo.stats.userPlaycount)
                XCTAssertEqual(artistInfo.stats.userPlaycount, 3808)

                XCTAssertEqual(artistInfo.similar.count, 5)
                XCTAssertEqual(artistInfo.similar[0].name, "Artist A")
                XCTAssertEqual(artistInfo.similar[0].url.absoluteString, "https://artists.com/artist-A")

                XCTAssertEqual(
                  artistInfo.similar[0].image.small?.absoluteString,
                  "https://images.com/artist-A-sm.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[0].image.medium?.absoluteString,
                  "https://images.com/artist-A-md.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[0].image.large?.absoluteString,
                  "https://images.com/artist-A-lg.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[0].image.extraLarge?.absoluteString,
                  "https://images.com/artist-A-xl.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[0].image.mega?.absoluteString,
                  "https://images.com/artist-A-mg.png"
                )

                XCTAssertEqual(artistInfo.similar[1].name, "Artist B")
                XCTAssertEqual(artistInfo.similar[1].url.absoluteString, "https://artists.com/artist-B")

                XCTAssertEqual(
                  artistInfo.similar[1].image.small?.absoluteString,
                  "https://images.com/artist-B-sm.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[1].image.medium?.absoluteString,
                  "https://images.com/artist-B-md.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[1].image.large?.absoluteString,
                  "https://images.com/artist-B-lg.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[1].image.extraLarge?.absoluteString,
                  "https://images.com/artist-B-xl.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[1].image.mega?.absoluteString,
                  "https://images.com/artist-B-mg.png"
                )

                XCTAssertEqual(artistInfo.similar[2].name, "Artist C")
                XCTAssertEqual(artistInfo.similar[2].url.absoluteString, "https://artists.com/artist-C")

                XCTAssertEqual(
                  artistInfo.similar[2].image.small?.absoluteString,
                  "https://images.com/artist-C-sm.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[2].image.medium?.absoluteString,
                  "https://images.com/artist-C-md.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[2].image.large?.absoluteString,
                  "https://images.com/artist-C-lg.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[2].image.extraLarge?.absoluteString,
                  "https://images.com/artist-C-xl.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[2].image.mega?.absoluteString,
                  "https://images.com/artist-C-mg.png"
                )

                XCTAssertEqual(artistInfo.similar[3].name, "Artist D")
                XCTAssertEqual(artistInfo.similar[3].url.absoluteString, "https://artists.com/artist-D")

                XCTAssertEqual(
                  artistInfo.similar[3].image.small?.absoluteString,
                  "https://images.com/artist-D-sm.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[3].image.medium?.absoluteString,
                  "https://images.com/artist-D-md.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[3].image.large?.absoluteString,
                  "https://images.com/artist-D-lg.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[3].image.extraLarge?.absoluteString,
                  "https://images.com/artist-D-xl.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[3].image.mega?.absoluteString,
                  "https://images.com/artist-D-mg.png"
                )

                XCTAssertEqual(artistInfo.similar[4].name, "Artist E")
                XCTAssertEqual(artistInfo.similar[4].url.absoluteString, "https://artists.com/artist-E")

                XCTAssertEqual(
                  artistInfo.similar[4].image.small?.absoluteString,
                  "https://images.com/artist-E-sm.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[4].image.medium?.absoluteString,
                  "https://images.com/artist-E-md.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[4].image.large?.absoluteString,
                  "https://images.com/artist-E-lg.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[4].image.extraLarge?.absoluteString,
                  "https://images.com/artist-E-xl.png"
                )

                XCTAssertEqual(
                  artistInfo.similar[4].image.mega?.absoluteString,
                  "https://images.com/artist-E-mg.png"
                )

                XCTAssertEqual(artistInfo.tags.count, 5)
                XCTAssertEqual(artistInfo.tags[0].name, "rock")

                XCTAssertEqual(
                  artistInfo.tags[0].url.absoluteString,
                  "https://tags.com/rock"
                )

                XCTAssertEqual(artistInfo.tags[1].name, "alternative rock")

                XCTAssertEqual(
                  artistInfo.tags[1].url.absoluteString,
                  "https://tags.com/alternative-rock"
                )

                XCTAssertEqual(artistInfo.tags[2].name, "Grunge")

                XCTAssertEqual(
                  artistInfo.tags[2].url.absoluteString,
                  "https://tags.com/Grunge"
                )

                XCTAssertEqual(artistInfo.tags[3].name, "alternative")

                XCTAssertEqual(
                  artistInfo.tags[3].url.absoluteString,
                  "https://tags.com/alternative"
                )

                XCTAssertEqual(artistInfo.tags[4].name, "seen live")

                XCTAssertEqual(
                  artistInfo.tags[4].url.absoluteString,
                  "https://tags.com/seen-live"
                )

                let dateComponents = DateComponents(
                    calendar: Calendar.current,
                    timeZone: TimeZone(secondsFromGMT: 0),
                    year: 2006,
                    month: 2,
                    day: 10,
                    hour: 19,
                    minute: 13
                )

                let date = Calendar.current.date(from: dateComponents)

                XCTAssertEqual(artistInfo.bio.published, date)
                XCTAssertEqual(artistInfo.bio.summary, "Some summary.")
                XCTAssertEqual(artistInfo.bio.content, "Some content.")
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?format=json&username=pepiro&artist=Some%20Artist&api_key=someAPIKey&autocorrect=1&method=artist.getInfo&lang=en"
            )
        )
    }

    func test_getInfo_no_username() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getInfo_noUsername",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = ArtistInfoParams(
            term: "Some Artist",
            criteria: .artist,
            lang: "es"
        )

        let expectation = expectation(description: "waiting for getInfo")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let artistInfo):
                XCTAssertNil(artistInfo.stats.userPlaycount)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?format=json&artist=Some%20Artist&api_key=someAPIKey&autocorrect=1&method=artist.getInfo&lang=es"
            )
        )
    }

    func test_getInfo_byMBID_with_username() throws {
        let jsonURL = Bundle.module.url(
            forResource: "Resources/artist.getInfo_withUsername",
            withExtension: "json"
        )!

        let fakeData = try Data(contentsOf: jsonURL)

        let params = ArtistInfoParams(
            term: "some-mbid",
            criteria: .mbid,
            lang: "pt",
            username: "pepiro"
        )

        let expectation = expectation(description: "waiting for getInfo")

        apiClient.data = fakeData
        apiClient.response = Constants.RESPONSE_200_OK

        instance.getInfo(params: params) { result in
            switch (result) {
            case .success(let artistInfo):
                XCTAssertNotNil(artistInfo.stats.userPlaycount)
                XCTAssertEqual(artistInfo.stats.userPlaycount!, 3808)
            case .failure(let error):
                XCTFail("It was expected to succeed, but it failed with error \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.getCalls.count, 1)
        XCTAssertEqual(apiClient.getCalls[0].headers, nil)

        XCTAssertTrue(
            Util.areSameURL(
                apiClient.getCalls[0].url.absoluteString,
                "http://ws.audioscrobbler.com/2.0?format=json&mbid=some-mbid&api_key=someAPIKey&autocorrect=1&method=artist.getInfo&username=pepiro&lang=pt"
            )
        )
    }

    func test_addTags_success() throws {
        let expectation = expectation(description: "waiting for addTags()")
        let expectedPayload = "api_sig=748073bfa73432b7780f16bfb5454bb0&method=artist.addtags&tags=tag%201,tag-2,tag3&artist=Some%20Artists&api_key=someAPIKey&sk=someSession"

        apiClient.response = Constants.RESPONSE_200_OK
        apiClient.data = "{}".data(using: .utf8)

        try instance.addTags(artist: "Some Artists", tags: ["tag 1", "tag-2", "tag3"], sessionKey: "someSession") { error in
            if let error = error {
                XCTFail("It was expected to succeed, but it failed with error \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "http://domain.com/?" + payloadString,
                "http://domain.com/?" + expectedPayload
            )
        )
    }

    func test_removeTag_success() throws {
        let expectation = expectation(description: "waiting for removeTag()")
        let expectedPayload = "api_key=someAPIKey&method=artist.removetag&artist=Some%20Artists&api_sig=487eb33e6a735ae73ee5d00f6e19fadf&sk=someSession&tags=tag%201"

        apiClient.response = Constants.RESPONSE_200_OK
        apiClient.data = "{}".data(using: .utf8)

        try instance.removeTag(artist: "Some Artists", tag: "tag 1", sessionKey: "someSession") { error in
            if let error = error {
                XCTFail("It was expected to succeed, but it failed with error \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertEqual(apiClient.postCalls.count, 1)

        XCTAssertEqual(
            apiClient.postCalls[0].headers,
            ["Content-Type": "application/x-www-formurlencoded"]
        )

        XCTAssertEqual(
            apiClient.postCalls[0].url.absoluteString,
            "http://ws.audioscrobbler.com/2.0?format=json"
        )

        let payloadData = try XCTUnwrap(apiClient.postCalls[0].body)
        let payloadString = String(data: payloadData, encoding: .utf8)!

        XCTAssertTrue(
            Util.areSameURL(
                "http://domain.com/?" + payloadString,
                "http://domain.com/?" + expectedPayload
            )
        )
    }

}
