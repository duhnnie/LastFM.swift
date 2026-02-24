Pod::Spec.new do |s|
  s.name             = "LastFM.swift"
  s.version          = "1.6.0"
  s.summary          = "A library for consuming the last.fm API"

  s.description      = <<-DESC
    Library for consuming the Last.FM API, it covers all services listed in last.fm API page
                       DESC

  s.homepage         = "https://github.com/duhnnie/LastFM.swift"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Daniel Canedo Ramos" => "me@duhnnie.com" }
  s.source           = { :git => "https://github.com/duhnnie/LastFM.swift.git", :tag => s.version.to_s }

  ios_deployment_target = "11.0"
  osx_deployment_target = "10.15"
  watchos_deployment_target = "4.0"
  tvos_deployment_target = "11.0"

  s.ios.deployment_target = ios_deployment_target
  s.osx.deployment_target = osx_deployment_target
  s.watchos.deployment_target = watchos_deployment_target
  s.tvos.deployment_target = tvos_deployment_target

  s.module_name = "LastFM"

  s.swift_versions = ["5"]

  s.source_files = "Sources/LastFM/**/*"
  s.dependency "SwiftRestClient", ">= 0.7.1"
end
