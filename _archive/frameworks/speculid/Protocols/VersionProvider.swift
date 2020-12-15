import Foundation
import SwiftVer

public protocol VersionProvider {
  var version: Version? { get }
}
