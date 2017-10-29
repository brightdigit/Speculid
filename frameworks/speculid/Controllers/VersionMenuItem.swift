import Cocoa
import SwiftVer

extension Version {
  public var buildHexidecimal: String {
    return String(format: "%05x", build)
  }
}

public class VersionMenuItem: NSMenuItem {
  public init() {

    let version = Application.current.version
    super.init(title: "Speculid v\(version) [\(version.buildHexidecimal)]", action: nil, keyEquivalent: "")
  }

  public required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
}
