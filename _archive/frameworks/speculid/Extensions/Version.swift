import Foundation
import SwiftVer

public extension Version {
  var developmentDescription: String {
    let buildnumbers = VersionMenuItem.buildNumbers(fromResource: "build", withExtension: "list")
    let title: String
    if buildnumbers?.contains(build) == true {
      title = "Speculid v\(self)"
    } else {
      title = "Speculid v\(fullDescription) [dev-\(buildHexidecimal)]"
    }
    return title
  }
}
