import Foundation

public struct ScrobbleParams: Params {

    private(set) var items: [ScrobbleParamItem] = []
    public var sessionKey: String

    public init(sessionKey: String) {
        self.sessionKey = sessionKey
    }

    public init(sessionKey: String, scrobbleItem: ScrobbleParamItem) {
        self.init(sessionKey: sessionKey)
        self.items.append(scrobbleItem)
    }

    public mutating func addItem(item: ScrobbleParamItem) {
        self.items.append(item)
    }

    public mutating func clearItems() {
        self.items.removeAll()
    }

    internal func toDictionary() -> Dictionary<String, String> {
        var dict: [String: String] = items.enumerated().reduce([:]) { result, enumeratedItem in
            var newResult = result
            let index = enumeratedItem.offset
            let scrobbleItem = enumeratedItem.element

            newResult["artist[\(index)]"] = scrobbleItem.artist
            newResult["track[\(index)]"] = scrobbleItem.track
            newResult["timestamp[\(index)]"] = String(scrobbleItem.timestamp)

            if let album = scrobbleItem.album {
                newResult["album[\(index)]"] = album
            }

            if let context = scrobbleItem.context {
                newResult["context[\(index)]"] = context
            }

            if let streamId = scrobbleItem.streamId {
                newResult["streamId[\(index)]"] = streamId
            }

            if let chosenByUser = scrobbleItem.chosenByUser {
                newResult["chosenByUser[\(index)]"] = chosenByUser ? "1" : "0"
            }

            if let trackNumber = scrobbleItem.trackNumber {
                newResult["trackNumber[\(index)]"] = String(trackNumber)
            }

            if let mbid = scrobbleItem.mbid {
                newResult["mbid[\(index)]"] = mbid
            }

            if let albumArtist = scrobbleItem.albumArtist {
                newResult["albumArtist[\(index)]"] = albumArtist
            }

            if let duration = scrobbleItem.duration {
                newResult["duration[\(index)]"] = String(duration)
            }

            return newResult
        }

        dict["sk"] = self.sessionKey

        return dict
    }

}
