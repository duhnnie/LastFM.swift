import Foundation

fileprivate let USERTOPTRACKS: [[UserTopTracksTestUtils.PropertyKey: Any]] = [
    [
        .streamable: false,
        .mbid: "someMBID_0",
        .name: "someTrackName_0",
        .imageSmall: "https://some.sm/image_0.jpg",
        .imageMedium: "https://some.md/image_0.jpg",
        .imageLarge: "https://some.lg/image_0.jpg",
        .imageExtraLarge: "http://some.xl/image_0.jpg",
        .artistMBID: "someArtistMBID_0",
        .artistName: "someArtistName_0",
        .artistURL: "https://someartist-0.com",
        .url: "https://some.track/url-0",
        .duration: "200",
        .rank: "1",
        .playcount: "320"
    ],
    [
        .streamable: false,
        .mbid: "someMBID_1",
        .name: "someTrackName_1",
        .imageSmall: "https://some.sm/image_1.jpg",
        .imageMedium: "https://some.md/image_1.jpg",
        .imageLarge: "https://some.lg/image_1.jpg",
        .imageExtraLarge: "http://some.xl/image_1.jpg",
        .artistMBID: "someArtistMBID_1",
        .artistName: "someArtistName_1",
        .artistURL: "https://someartist-1.com",
        .url: "https://some.track/url-1",
        .duration: "201",
        .rank: "2",
        .playcount: "321"
    ],
    [
        .streamable: false,
        .mbid: "someMBID_2",
        .name: "someTrackName_2",
        .imageSmall: "https://some.sm/image_2.jpg",
        .imageMedium: "https://some.md/image_2.jpg",
        .imageLarge: "https://some.lg/image_2.jpg",
        .imageExtraLarge: "http://some.xl/image_2.jpg",
        .artistMBID: "someArtistMBID_2",
        .artistName: "someArtistName_2",
        .artistURL: "https://someartist-2.com",
        .url: "https://some.track/url-2",
        .duration: "202",
        .rank: "3",
        .playcount: "322"
    ],
    [
        .streamable: false,
        .mbid: "someMBID_3",
        .name: "someTrackName_3",
        .imageSmall: "https://some.sm/image_3.jpg",
        .imageMedium: "https://some.md/image_3.jpg",
        .imageLarge: "https://some.lg/image_3.jpg",
        .imageExtraLarge: "http://some.xl/image_3.jpg",
        .artistMBID: "someArtistMBID_3",
        .artistName: "someArtistName_3",
        .artistURL: "https://someartist-3.com",
        .url: "https://some.track/url-3",
        .duration: "203",
        .rank: "4",
        .playcount: "323"
    ],
]

internal struct UserTopTracksTestUtils {
    internal static let list = USERTOPTRACKS
    internal static let defaultValues = list[0]

    internal struct PropertyKey: Hashable, RawRepresentable {
        typealias RawValue = String
        var rawValue: String

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let streamable = PropertyKey(rawValue: "streamable")!
        public static let mbid = PropertyKey(rawValue: "mbid")!
        public static let name = PropertyKey(rawValue: "name")!
        public static let imageSmall = PropertyKey(rawValue: "imageSmall")!
        public static let imageMedium = PropertyKey(rawValue: "imageMedium")!
        public static let imageLarge = PropertyKey(rawValue: "imageLarge")!
        public static let imageExtraLarge = PropertyKey(rawValue: "imageExtraLarge")!
        public static let artistMBID = PropertyKey(rawValue: "artistMBID")!
        public static let artistName = PropertyKey(rawValue: "artistName")!
        public static let artistURL = PropertyKey(rawValue: "artistURL")!
        public static let url = PropertyKey(rawValue: "url")!
        public static let duration = PropertyKey(rawValue: "duration")!
        public static let rank = PropertyKey(rawValue: "rank")!
        public static let playcount = PropertyKey(rawValue: "playcount")!

    }

    internal static func generateJSON(
        streamable: Bool = defaultValues[.streamable] as! Bool,
        mbid: String = defaultValues[.mbid] as! String,
        name: String = defaultValues[.name] as! String,
        imageSmall: String = defaultValues[.imageSmall] as! String,
        imageMedium: String = defaultValues[.imageMedium] as! String,
        imageLarge: String = defaultValues[.imageLarge] as! String,
        imageExtraLarge: String = defaultValues[.imageExtraLarge] as! String,
        artistMBID: String = defaultValues[.artistMBID] as! String,
        artistName: String = defaultValues[.artistName] as! String,
        artistURL: String = defaultValues[.artistURL] as! String,
        url: String = defaultValues[.url] as! String,
        duration: String = defaultValues[.duration] as! String,
        rank: String = defaultValues[.rank] as! String,
        playcount: String = defaultValues[.playcount] as! String
    ) -> String {
        return """
{
  "streamable": {
    "fulltrack": "\(streamable ? "1" : "0")",
    "#text": "\(streamable ? "1" : "0")"
  },
  "mbid": "\(mbid)",
  "name": "\(name)",
  "image": \(LastFMImagesTests.generateJSON(
    small: imageSmall, medium: imageMedium, large: imageLarge, extraLarge: imageExtraLarge
)),
  "artist": {
    "url": "\(artistURL)",
    "name": "\(artistName)",
    "mbid": "\(artistMBID)"
  },
  "url": "\(url)",
  "duration": "\(duration)",
  "@attr": {
    "rank": "\(rank)"
  },
  "playcount": "\(playcount)"
}
"""
    }

    internal static func generateJSON(dataset: [PropertyKey: Any]) -> String {
        return generateJSON(
            streamable: dataset[.streamable] as! Bool,
            mbid: dataset[.mbid] as! String,
            name: dataset[.name] as! String,
            imageSmall: dataset[.imageSmall] as! String,
            imageMedium: dataset[.imageMedium] as! String,
            imageLarge: dataset[.imageLarge] as! String,
            imageExtraLarge: dataset[.imageExtraLarge] as! String,
            artistMBID: dataset[.artistMBID] as! String,
            artistName: dataset[.artistName] as! String,
            artistURL: dataset[.artistURL] as! String,
            url: dataset[.url] as! String,
            duration: dataset[.duration] as! String,
            rank: dataset[.rank] as! String,
            playcount: dataset[.playcount] as! String
        )
    }

    internal static func generateJSON(index: Int) -> String {
        let dataset = list[index]

        return generateJSON(dataset: dataset)
    }
}
