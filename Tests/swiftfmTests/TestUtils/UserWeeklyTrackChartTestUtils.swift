import Foundation

fileprivate let LIST: [[UserWeeklyTrackChartTestUtils.PropertyKey: String]] = [
    [
        .mbid: "some mbid 1",
        .name: "some name 1",
        .url: "http://some-1.url",
        .artistMBID: "some artist mbid 1",
        .artistName: "some artist name 1",
        .imageSmall: "http://some.image.net/small-1.jpg",
        .imageMedium: "http://some.image.net/medium-1.jpg",
        .imageLarge: "http://some.image.net/large-1.jpg",
        .imageExtraLarge: "http://some.image.net/extralarge-1.jpg",
        .playcount: "101",
        .rank: "1"
    ],
    [
        .mbid: "some mbid 2",
        .name: "some name 2",
        .url: "http://some-2.url",
        .artistMBID: "some artist mbid 2",
        .artistName: "some artist name 2",
        .imageSmall: "http://some.image.net/small-2.jpg",
        .imageMedium: "http://some.image.net/medium-2.jpg",
        .imageLarge: "http://some.image.net/large-2.jpg",
        .imageExtraLarge: "http://some.image.net/extralarge-2.jpg",
        .playcount: "102",
        .rank: "2"
    ],
    [
        .mbid: "some mbid 3",
        .name: "some name 3",
        .url: "http://some-3.url",
        .artistMBID: "some artist mbid 3",
        .artistName: "some artist name 3",
        .imageSmall: "http://some.image.net/small-3.jpg",
        .imageMedium: "http://some.image.net/medium-3.jpg",
        .imageLarge: "http://some.image.net/large-3.jpg",
        .imageExtraLarge: "http://some.image.net/extralarge-3.jpg",
        .playcount: "103",
        .rank: "3"
    ],
    [
        .mbid: "some mbid 4",
        .name: "some name 4",
        .url: "http://some-4.url",
        .artistMBID: "some artist mbid 4",
        .artistName: "some artist name 4",
        .imageSmall: "http://some.image.net/small-4.jpg",
        .imageMedium: "http://some.image.net/medium-4.jpg",
        .imageLarge: "http://some.image.net/large-4.jpg",
        .imageExtraLarge: "http://some.image.net/extralarge-4.jpg",
        .playcount: "104",
        .rank: "4"
    ]
]

internal struct UserWeeklyTrackChartTestUtils {
    internal static let list = LIST
    internal static let defaultValues = list[0]

    internal struct PropertyKey: Hashable, RawRepresentable {
        typealias RawValue = String
        var rawValue: String

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let mbid = PropertyKey(rawValue: "mbid")!
        public static let name = PropertyKey(rawValue: "name")!
        public static let url = PropertyKey(rawValue: "url")!
        public static let artistMBID = PropertyKey(rawValue: "artistMBID")!
        public static let artistName = PropertyKey(rawValue: "artistName")!
        public static let imageSmall = PropertyKey(rawValue: "imageSmall")!
        public static let imageMedium = PropertyKey(rawValue: "imageMedium")!
        public static let imageLarge = PropertyKey(rawValue: "imageLarge")!
        public static let imageExtraLarge = PropertyKey(rawValue: "imageExtraLarge")!
        public static let playcount = PropertyKey(rawValue: "playcount")!
        public static let rank = PropertyKey(rawValue: "rank")!
    }

    internal static func generateJSON(
        mbid: String = defaultValues[.mbid]!,
        name: String = defaultValues[.name]!,
        url: String = defaultValues[.url]!,
        artistMBID: String = defaultValues[.artistMBID]!,
        artistName: String = defaultValues[.artistName]!,
        imageSmall: String = defaultValues[.imageSmall]!,
        imageMedium: String = defaultValues[.imageMedium]!,
        imageLarge: String = defaultValues[.imageLarge]!,
        imageExtraLarge: String = defaultValues[.imageExtraLarge]!,
        playcount: String = defaultValues[.playcount]!,
        rank: String = defaultValues[.rank]!
    ) -> String {
        return """
{
  "artist": {
    "mbid": "\(artistMBID)",
    "#text": "\(artistName)"
  },
  "image": \(LastFMImagesTests.generateJSON(
    small: imageSmall,
    medium: imageMedium,
    large: imageLarge,
    extraLarge: imageExtraLarge
)),
  "mbid": "\(mbid)",
  "url": "\(url)",
  "name": "\(name)",
  "@attr": {
    "rank": "\(rank)"
  },
  "playcount": "\(playcount)"
}
"""
    }

    internal static func generateJSON(dataset: [PropertyKey: String]) -> String {
        return generateJSON(
            mbid: dataset[.mbid]!,
            name: dataset[.name]!,
            url: dataset[.url]!,
            artistMBID: dataset[.artistMBID]!,
            artistName: dataset[.artistName]!,
            imageSmall: dataset[.imageSmall]!,
            imageMedium: dataset[.imageMedium]!,
            imageLarge: dataset[.imageLarge]!,
            imageExtraLarge: dataset[.imageExtraLarge]!,
            playcount: dataset[.playcount]!,
            rank: dataset[.rank]!
        )
    }
}
