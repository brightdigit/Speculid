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
        return Set(text.components(separatedBy: CharacterSet.newlines).flatMap { Int($0) })
      }
    }
    return nil
  }

  public init() {
    let title: String

    if let version = Application.current.version, Application.vcs != nil {
      title = version.developmentDescription
    } else {
      title = "\(String(describing: Application.bundle.infoDictionary?["CFBundleShortVersionString"])) (\(String(describing: Application.bundle.infoDictionary?["CFBundleVersion"])))"
    }
    super.init(title: title, action: nil, keyEquivalent: "")
  }

  public required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
