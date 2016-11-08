Pod::Spec.new do |s|

  s.name         = "WarpSDK"
  s.version      = "1.0.0"
  s.summary      = "The Warp iOS SDK is a library designed to work with projects built on-top of the Warp Server."
  s.homepage     = "https://github.com/dividedbyzeroco/warp-server"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Zonily Jame Pesquera" => "zonilyjame@gmail.com" }
  s.social_media_url   = "http://twitter.com/kuyazee"

  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/kuyazee/WarpSDK-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "WarpSDK", "WarpSDK/**/*.{h,swift}"

  # s.public_header_files = "Classes/**/*.h"



  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"

  # s.dependency "Curry", "~> 1.4.0"
  s.dependency "Alamofire", "~> 3.5.0"
  # s.frameworks = "Alamofire", "EVReflection"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
