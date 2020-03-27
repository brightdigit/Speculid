import Foundation
import SwiftVer

public extension Version {
  var developmentDescription: String {
    let buildnumbers = VersionMenuItem.buildNumbers(fromResource: "build", withExtension: "list")
    let title: String
    if buildnumbers?.contains(build) == true {
      title = "Speculid v\(self) [\(buildHexidecimal)]"
    } else {
      title = "Speculid v\(fullDescription) [dev-\(buildHexidecimal)]"
    }
    return title
  }
}
