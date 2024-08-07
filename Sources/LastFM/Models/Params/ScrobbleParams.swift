import Foundation

public struct ScrobbleParams: Params {

    public var count: Int {
        return self.items.count
    }
    
    private var items: [ScrobbleParamItem] = []

    public init(scrobbleItem: ScrobbleParamItem? = nil) {
        if let scrobbleItem = scrobbleItem {
            self.items.append(scrobbleItem)
        }
    }

    public mutating func addItem(item: ScrobbleParamItem) throws {
        guard self.items.count < 50 else {
            throw ScrobbleError.TooMuchScrobbleIItems
        }
        
        self.items.append(item)
    }

    public mutating func clearItems() {
        self.items.removeAll()
    }

    internal func toDictionary() -> Dictionary<String, String> {
        let dict: [String: String] = items.enumerated().reduce([:]) { result, enumeratedItem in
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

        return dict
    }

}
