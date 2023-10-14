import XCTest
@testable import swiftfm

class UserWeeklyTrackChartTests: XCTestCase {

    static private let defaultValues = UserWeeklyTrackChartTestUtils.defaultValues

    func test_successful_decoding() throws {
        let data = UserWeeklyTrackChartTestUtils.generateJSON()
            .data(using: .utf8)!

        let instance = try JSONDecoder().decode(
            UserWeeklyChartTrack.self,
            from: data
        )

        XCTAssertEqual(instance.mbid, Self.defaultValues[.mbid]!)
        XCTAssertEqual(instance.name, Self.defaultValues[.name]!)
        XCTAssertEqual(instance.url.absoluteString, Self.defaultValues[.url]!)
        XCTAssertEqual(instance.artist.mbid, Self.defaultValues[.artistMBID]!)
        XCTAssertEqual(instance.artist.name, Self.defaultValues[.artistName]!)
        XCTAssertEqual(instance.images.small?.absoluteString, Self.defaultValues[.imageSmall]!)
        XCTAssertEqual(instance.images.medium?.absoluteString, Self.defaultValues[.imageMedium]!)
        XCTAssertEqual(instance.images.large?.absoluteString, Self.defaultValues[.imageLarge]!)
        XCTAssertEqual(instance.images.extraLarge?.absoluteString, Self.defaultValues[.imageExtraLarge]!)
        XCTAssertEqual(instance.playcount, UInt(Self.defaultValues[.playcount]!))
        XCTAssertEqual(instance.rank, UInt(Self.defaultValues[.rank]!))
    }

    func test_unsuccessful_decoding_due_rank() throws {
        let data = UserWeeklyTrackChartTestUtils.generateJSON(
            rank: "not a valid rank"
        ).data(using: .utf8)!

        XCTAssertThrowsError(
            try JSONDecoder().decode(UserWeeklyChartTrack.self, from: data),
            "It was expected to fail, but it succeeded") { error in
                XCTAssert(error is RuntimeError)
                XCTAssertEqual(error.localizedDescription, "Invalid rank.")
            }
    }

    func test_unsuccessful_decoding_due_playcount() throws {
        let data = UserWeeklyTrackChartTestUtils.generateJSON(
            playcount: "not a valid playcount"
        ).data(using: .utf8)!

        XCTAssertThrowsError(
            try JSONDecoder().decode(UserWeeklyChartTrack.self, from: data),
            "It was expected to fail, but it succeeded") { error in
                XCTAssert(error is RuntimeError)
                XCTAssertEqual(error.localizedDescription, "Invalid playcount.")
            }
    }
}
