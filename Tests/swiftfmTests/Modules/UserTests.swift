//
//  UserTests.swift
//  
//
//  Created by Daniel on 11/10/23.
//

import XCTest
@testable import swiftfm

class UserTests: XCTestCase {

    private static let apiKey = "someAPIkey"
    private static let apiSecret = "someAPIsecret"
    private static let swiftFM = SwiftFM(apiKey: apiKey, apiSecret: apiSecret)

    private var instance: User!
    private var requester: RequesterMock = RequesterMock(
        url: URL(string: "http://someURL.com")!,
        makeRequestData: Data()
    )

    override func setUpWithError() throws {
        instance = User(instance: Self.swiftFM, requester: requester)
    }

    override func tearDownWithError() throws {
        requester.makeRequestError = nil
        requester.clearMock()
    }

    // getTopTracks

    func test_getTopTracks_success() throws {
        let topTracksItemsJSON = UserTopTracksTestUtils.list.map { dataset in
            return UserTopTracksTestUtils.generateJSON(dataset: dataset)
        }.joined(separator: ",")
        let expectedData = CollectionPageTestUtils.generateJSON(
            items: "[\(topTracksItemsJSON)]",
            totalPages: "10",
            page: "1",
            perPage: "4",
            total: "40"
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

        let parsedParams = [
            ("method", "user.getTopTracks"),
            ("user", params.user),
            ("limit", String(params.limit)),
            ("page", String(params.page)),
            ("period", params.period.rawValue),
            ("api_key", Self.apiKey),
            ("format", "json")
        ]

        requester.makeRequestData = expectedData
        requester.makeRequestError = nil
        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success(let userTopTracks):
                for (index, track) in userTopTracks.items.enumerated() {
                    XCTAssertEqual(track.mbid, UserTopTracksTestUtils.list[index][.mbid] as! String)
                    XCTAssertEqual(track.name, UserTopTracksTestUtils.list[index][.name] as! String)
                    XCTAssertEqual(
                        track.images.small!.absoluteString,
                        UserTopTracksTestUtils.list[index][.imageSmall] as! String
                    )
                    XCTAssertEqual(
                        track.images.medium!.absoluteString,
                        UserTopTracksTestUtils.list[index][.imageMedium] as! String
                    )
                    XCTAssertEqual(
                        track.images.large!.absoluteString,
                        UserTopTracksTestUtils.list[index][.imageLarge] as! String
                    )
                    XCTAssertEqual(
                        track.images.extraLarge!.absoluteString,
                        UserTopTracksTestUtils.list[index][.imageExtraLarge] as! String
                    )
                    XCTAssertEqual(track.streamable, UserTopTracksTestUtils.list[index][.streamable] as! Bool)
                    XCTAssertEqual(track.artist.mbid, UserTopTracksTestUtils.list[index][.artistMBID] as! String)
                    XCTAssertEqual(track.artist.name, UserTopTracksTestUtils.list[index][.artistName] as! String)
                    XCTAssertEqual(
                        track.artist.url.absoluteString,
                        UserTopTracksTestUtils.list[index][.artistURL] as! String
                    )
                    XCTAssertEqual(track.url.absoluteString, UserTopTracksTestUtils.list[index][.url] as! String)
                    XCTAssertEqual(
                        track.duration,
                        UInt(UserTopTracksTestUtils.list[index][.duration] as! String)!
                    )
                    XCTAssertEqual(
                        track.rank,
                        UInt(UserTopTracksTestUtils.list[index][.rank] as! String)!
                    )
                    XCTAssertEqual(
                        track.playcount,
                        UInt(UserTopTracksTestUtils.list[index][.playcount] as! String)!
                    )
                }
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
        }

        XCTAssertEqual(requester.buildCalls.count, 1)
        XCTAssertEqual(requester.buildReturns.count, 1)

        for (index, param) in requester.buildCalls[0].params.enumerated() {
            XCTAssertEqual(param.0, parsedParams[index].0)
        }

        XCTAssertEqual(requester.makeGetRequestCalls.count, 1)
        XCTAssertEqual(
            requester.makeGetRequestCalls[0].url,
            requester.buildReturns[0]
        )
    }

    func test_getTopTracks_failure_dueSomeErrorInRequester() throws {
        let params = UserTopTracksParams(
            user: "user",
            period: .last180days,
            limit: 10,
            page: 2
        )

        requester.makeRequestError = .NoData

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(ServiceError.NoData):
                XCTAssert(true)
            default:
                XCTFail("Expected to be a .NoData error")
                break
            }
        }
    }

    func test_getTopTracks_failure_dueSomeErrorAtDecoding() throws {
        let params = UserTopTracksParams(
            user: "user",
            period: .last180days,
            limit: 10,
            page: 2
        )

        let topTrackJSONString = UserTopTracksTestUtils.generateJSON(duration: "not a number")
        let dataWithInvalidData = CollectionPageTestUtils.generateJSON(
            items: "[\(topTrackJSONString)]",
            totalPages: "1",
            page: "1",
            perPage: "10",
            total: "1"
        )

        requester.makeRequestData = dataWithInvalidData

        instance.getTopTracks(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(let error):
                XCTAssertFalse(error is ServiceError, "Expected to not be a Service Error")
            }
        }
    }

    // getWeeklyTrackChart

    func test_getWeeklyTrackChart_success() throws {
        let weeklyChartTracksJSON = UserWeeklyTrackChartTestUtils.list.map { dataset in
            return UserWeeklyTrackChartTestUtils.generateJSON(dataset: dataset)
        }.joined(separator: ",")

        let expectedData = CollectionListTestUtils.generateJSON(
            items: "[\(weeklyChartTracksJSON)]"
        ).data(using: .utf8)!

        let user = "Pepito"
        let from: UInt = 1665622629
        let to: UInt = 1697158629

        let params = UserWeeklyTrackChartParams(user: user, from: from, to: to)

        let parsedParams = [
            ("method", "user.getWeeklyTrackChart"),
            ("user", "Pepito"),
            ("from", "1665622629"),
            ("to", "1697158629"),
            ("api_key", "someAPIkey"),
            ("format", "json")
        ]

        requester.makeRequestData = expectedData
        requester.makeRequestError = nil
        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success(let weeklytrackchart):
                for (index, track) in weeklytrackchart.items.enumerated() {
                    XCTAssertEqual(track.mbid, UserWeeklyTrackChartTestUtils.list[index][.mbid]!)
                    XCTAssertEqual(track.name, UserWeeklyTrackChartTestUtils.list[index][.name]!)
                    XCTAssertEqual(
                        track.images.small!.absoluteString,
                        UserWeeklyTrackChartTestUtils.list[index][.imageSmall]!
                    )
                    XCTAssertEqual(
                        track.images.medium!.absoluteString,
                        UserWeeklyTrackChartTestUtils.list[index][.imageMedium]!
                    )
                    XCTAssertEqual(
                        track.images.large!.absoluteString,
                        UserWeeklyTrackChartTestUtils.list[index][.imageLarge]!
                    )
                    XCTAssertEqual(
                        track.images.extraLarge!.absoluteString,
                        UserWeeklyTrackChartTestUtils.list[index][.imageExtraLarge]!
                    )
                    XCTAssertEqual(track.artist.mbid, UserWeeklyTrackChartTestUtils.list[index][.artistMBID]!)
                    XCTAssertEqual(track.artist.name, UserWeeklyTrackChartTestUtils.list[index][.artistName]!)

                    XCTAssertEqual(track.url.absoluteString, UserWeeklyTrackChartTestUtils.list[index][.url]!)
                    XCTAssertEqual(
                        track.rank,
                        UInt(UserWeeklyTrackChartTestUtils.list[index][.rank]!)!
                    )
                    XCTAssertEqual(
                        track.playcount,
                        UInt(UserWeeklyTrackChartTestUtils.list[index][.playcount]!)!
                    )
                }
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
        }

        XCTAssertEqual(requester.buildCalls.count, 1)
        XCTAssertEqual(requester.buildReturns.count, 1)

        for (index, param) in requester.buildCalls[0].params.enumerated() {
            XCTAssertEqual(param.0, parsedParams[index].0)
        }

        XCTAssertEqual(requester.makeGetRequestCalls.count, 1)
        XCTAssertEqual(
            requester.makeGetRequestCalls[0].url,
            requester.buildReturns[0]
        )
    }

    func test_getWeeklyTrackChart_failure_dueSomeErrorInRequester()  throws {
        let params = UserWeeklyTrackChartParams(
            user: "user",
            from: 45325232,
            to: 345234523
        )

        requester.makeRequestError = .NoData

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(ServiceError.NoData):
                XCTAssert(true)
            default:
                XCTFail("Expected to be a .NoData error")
                break
            }
        }
    }

    func test_getWeeklyTrackChart_failure_dueSomeErrorAtDecoding() throws {
        let params = UserWeeklyTrackChartParams(
            user: "user",
            from: 4354452343,
            to: 4456345342
        )

        let topTrackJSONString = UserWeeklyTrackChartTestUtils.generateJSON(playcount: "not a number")
        let dataWithInvalidData = CollectionListTestUtils.generateJSON(
            items: "[\(topTrackJSONString)]"
        ).data(using: .utf8)!

        requester.makeRequestData = dataWithInvalidData

        instance.getWeeklyTrackChart(params: params) { result in
            switch (result) {
            case .success( _):
                XCTFail("Expected to fail, but it succeeded")
            case .failure(let error):
                XCTAssertFalse(error is ServiceError, "Expected to not be a Service Error")
            }
        }
    }
}
