import Foundation

public enum ImageIdiom: String, Codable {
  case universal,
    iphone,
    ipad,
    mac,
    tv,
    watch,
    car,
    watchMarketing = "watch-marketing",
    iosMarketing = "ios-marketing"
}
