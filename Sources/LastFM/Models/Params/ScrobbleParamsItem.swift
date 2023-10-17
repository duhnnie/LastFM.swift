import Foundation

public struct ScrobbleParamItem {

    public var artist: String
    public var track: String
    public var timestamp: UInt
    public var album: String?
    public var context: String?
    public var streamId: String?
    public var chosenByUser: Bool?
    public var trackNumber: UInt?
    public var mbid: String?
    public var albumArtist: String?
    public var duration: UInt?

    public init(
        artist: String,
        track: String,
        timestamp: UInt,
        album: String? = nil,
        context: String? = nil,
        streamId: String? = nil,
        chosenByUser: Bool? = nil,
        trackNumber: UInt? = nil,
        mbid: String? = nil,
        albumArtist: String? = nil,
        duration: UInt? = nil
    ) {
        self.artist = artist
        self.track = track
        self.timestamp = timestamp
        self.album = album
        self.context = context
        self.streamId = streamId
        self.chosenByUser = chosenByUser
        self.trackNumber = trackNumber
        self.mbid = mbid
        self.albumArtist = albumArtist
        self.duration = duration
    }

    public init(
        artist: String,
        track: String,
        date: Date,
        album: String? = nil,
        context: String? = nil,
        streamId: String? = nil,
        chosenByUser: Bool? = nil,
        trackNumber: UInt? = nil,
        mbid: String? = nil,
        albumArtist: String? = nil,
        duration: UInt? = nil
    ) {
        let timestamp = UInt(date.timeIntervalSince1970)

        self.init(
            artist: artist,
            track: track,
            timestamp: timestamp,
            album: album,
            context: context,
            streamId: streamId,
            chosenByUser: chosenByUser,
            trackNumber: trackNumber,
            mbid: mbid,
            albumArtist: albumArtist,
            duration: duration
        )
    }

}
