import Foundation
import AppKit

public protocol SpeculidSpecificationsFileProtocol {
  var contentsDirectoryURL: URL { get }
  var sourceImageURL: URL { get }
  var geometry: Geometry? { get }
  var background: NSColor? { get }
  var removeAlpha: Bool { get }
}
