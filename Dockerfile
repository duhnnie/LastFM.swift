FROM swiftlang/swift:nightly-focal

COPY ./ ./

CMD swift test
