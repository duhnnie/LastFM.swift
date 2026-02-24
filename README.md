# LastFM.swift
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fduhnnie%2FLastFM.swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/duhnnie/LastFM.swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fduhnnie%2FLastFM.swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/duhnnie/LastFM.swift)

A library for consuming the last.fm API. This library covers all services listed in [last.fm API page](https://www.last.fm/api).

## Installation

### Swift Package Manager

The [Swift Package Manager][] is a tool for managing the distribution of
Swift code.

1. Add the following to your `Package.swift` file:

  ```swift
  dependencies: [
      .package(url: "https://github.com/duhnnie/LastFM.swift", from: "1.6.0")
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
    github "duhnnie/LastFM.swift" ~> 1.6.0
    ```

 3. Run `carthage update` and
    [add the appropriate framework][Carthage Usage].


[Carthage]: https://github.com/Carthage/Carthage
[Carthage Installation]: https://github.com/Carthage/Carthage#installing-carthage
[Carthage Usage]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

### CocoaPods

[CocoaPods][] is a dependency manager for Cocoa projects. To install
LastFM.swift with CocoaPods:

 1. Make sure CocoaPods is [installed][CocoaPods Installation].

    ```sh
    # Using the default Ruby install will require you to use sudo when
    # installing and updating gems.
    [sudo] gem install cocoapods
    ```

 2. Update your Podfile to include the following:

    ```ruby
    use_frameworks!

    target 'YourAppTargetName' do
        pod 'LastFM.swift', '~> 1.6.0'
    end
    ```

 3. Run `pod install --repo-update`.

[CocoaPods]: https://cocoapods.org
[CocoaPods Installation]: https://guides.cocoapods.org/using/getting-started.html#getting-started

## Usage
You will need a last.fm API account, you can get one [here](https://www.last.fm/api/account/create).
Once you have an API account, you will need to create a LastFM.swift instance providing the **api key** and **api secret**:

```swift
import LastFM

let lastFM = LastFM(apiKey: "your_api_key", apiSecret: "your_api_secret")
```

After that, you'll be able to start consuming services (check [here](https://www.last.fm/api) for info/docs about all available services):

Using async/await:

```swift
let recentTrackParams = RecentTracksParams(user: "someUser", limit: 10, page: 1)
                
do {
    let recentTracks = try await lastFM.User.getRecentTracks(params: recentTrackParams)
    
    for track in recentTracks.items {
        print("\(track.artist.name) - \(track.name) - \(track.nowPlaying ? "🔈" : track.date!.debugDescription)")
    }
} catch LastFMError.LastFMServiceError(let errorType, let message) {
    print(errorType, message)
} catch LastFMError.NoData {
    print("No data was returned.")
} catch {
    print("An error ocurred: \(error)")
}

```

Using completion handlers:

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
            print("No data was returned.")
        case .OtherError(let error):
            print("An error ocurred: \(error)")
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

try scrobbleParams.addItem(
  item: ScrobbleParamItem(
    artist: "The Strokes",
    track: "The Adults Are Talking",
    date: Date(),
    album: "The New Abnormal"
  )
)

let scrobble = try await lastFM.Track.scrobble(params: scrobbleParams, sessionKey: "your-session-key")

// Or using the completion handler version:
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

## Linux support
LastFM.swift is supported by Linux. However running the tests results in a fatal error:

```
Fatal error: Constant strings cannot be deallocated
```
So that's why some test running in GitHub Actions. Anyway, you can run the tests in a local Docker container (it has a different Swift version) by running:
```
./runLinuxTests.sh
```

### About the issues in Linux
- https://github.com/apple/swift/issues/56730
- https://github.com/apple/swift-corelibs-foundation/issues/4804

## Contribution

 - Found a **bug** or have a **feature request**? [Open an issue][].
 - Want to **contribute**? [Submit a pull request][].

[Open an issue]: https://github.com/duhnnie/lastFM.swift/issues/new
[Submit a pull request]: https://github.com/duhnnie/lastFM.swift/fork


## Original author

 - [Daniel Canedo](mailto:me@duhnnie.com)
   ([@duhnnie](https://twitter.com/duhnnie))


## License

LastFM.swift is available under the MIT license. See [the LICENSE
file](./LICENSE.txt) for more information.
