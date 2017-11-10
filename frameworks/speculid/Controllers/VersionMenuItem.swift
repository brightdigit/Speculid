import Cocoa
import SwiftVer

extension Version {
  public var buildHexidecimal: String {
    return String(format: "%05x", build)
  }
}

public class VersionMenuItem: NSMenuItem {
  public static func buildNumbers(fromResource resource: String?, withExtension extension: String?) -> Set<Int>? {

    if let url = Application.bundle.url(forResource: resource, withExtension: `extension`) {
      if let text = try? String(contentsOf: url) {
        return Set(text.split(separator: " ").flatMap { Int($0) })
      }
    }
    return nil
  }

  public init() {
    let title = Application.current.version.developmentDescription
    super.init(title: title, action: nil, keyEquivalent: "")
  }

  public required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
