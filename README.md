# LastFM.swift

A library for consuming last.fm API. This library covers all services listed in [last.fm API page](https://www.last.fm/api).

## Installation

### Swift Package Manager

The [Swift Package Manager][] is a tool for managing the distribution of
Swift code.

1. Add the following to your `Package.swift` file:

  ```swift
  dependencies: [
      .package(url: "https://github.com/duhnnie/LastFM.swift", from: "1.0.0")
  ]
  ```

2. Build your project:

  ```sh
  $ swift build
  ```

[Swift Package Manager]: https://swift.org/package-manager

### Carthage

[Carthage][] is a simple, decentralized dependency manager for Cocoa. To
install LastFM.swift with Carthage:

 1. Make sure Carthage is [installed][Carthage Installation].

 2. Update your Cartfile to include the following:

    ```ruby
    github "duhnnie/LastFM.swift" ~> 1.0.0
    ```

 3. Run `carthage update` and
    [add the appropriate framework][Carthage Usage].


[Carthage]: https://github.com/Carthage/Carthage
[Carthage Installation]: https://github.com/Carthage/Carthage#installing-carthage
[Carthage Usage]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

## Usage
You will need a last.fm API account, you can get one [here](https://www.last.fm/api/account/create).
Once you have an API account, you will need to create a LastFM.swift instance providing the **api key** and **api secret**:

```swift
import LastFM

let lastFM = LastFM(apiKey: "your_api_key", apiSecret: "your_api_secret")
```

After that, you'll be able to start consuming services:

```swift
let recentTrackParams = RecentTracksParams(user: "someUser", limit: 10, page: 1)

lastFM.User.getRecentTracks(params: recentTrackParams) { result in
    switch (result) {
    case .failure(let error):
        print("error message: \(error.localizedDescription)")

        switch(error) {
        case .LastFMServiceError(let lastfmErrorType, let message):
            print(lastfmErrorType, message)
        case .NoData:
            print("No data was returned")
        case .OtherError(let error):
            print("An error ocurred \(error)")
        }
    case .success(let obj):
        for track in obj.items {
            print("\(track.artist.name) - \(track.name) - \(track.nowPlaying ? "🔈" : track.date!.debugDescription)")
        }
    }
}

```
### Authentication
Some services require authentication and this library provides all necessary methods for it (you can read about all authentication paths provided by last.fm [here](https://www.last.fm/api/authentication)).

For example, for scrobbling a track to your last.fm profile, you need to provide the *session key* you get from any of the [last.fm authentication paths](https://www.last.fm/api/authentication), so last.fm knows which account the track should go to.

```swift
var scrobbleParams = ScrobbleParams()

scrobbleParams.addItem(
  item: ScrobbleParamItem(
    artist: "The Strokes",
    track: "The Adults Are Talking",
    date: Date(),
    album: "The New Abnormal"
  )
)

try lastFM.Track.scrobble(
  params: scrobbleParams,
  sessionKey: "your_session_key",
  onCompletion: { result in
    switch (result) {
    case .success(let scrobble):
        print(scrobble)
    case .failure(let error):
        print(error)
    }
  }
)
```
