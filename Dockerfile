FROM swift:latest
# FROM swiftlang/swift:nightly-focal

# Set the working directory inside the container
WORKDIR /app

# Copy the Swift Package Manager manifest files (Package.swift and Package.resolved) first
# This will allow Docker to cache dependencies separately from the source code
COPY Package.swift Package.resolved ./

# Resolve dependencies and cache the result
RUN swift package resolve

# Copy the remaining source files (now that dependencies are cached)
COPY . .

# RUN swift build --build-tests
RUN swift build -c debug

# Run the tests with verbose output
CMD swift test -v
