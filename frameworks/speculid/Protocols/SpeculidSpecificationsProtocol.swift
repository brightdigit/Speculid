import Foundation
import AppKit

public protocol SpeculidSpecificationsProtocol {
  var contentsDirectoryURL: URL { get }
  var sourceImageURL: URL { get }
  var geometry: Geometry? { get }
  var background: NSColor? { get }
  var removeAlpha: Bool { get }
}
