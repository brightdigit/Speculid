import AppKit
import Foundation

public protocol SpeculidSpecificationsFileProtocol {
  var assetDirectoryRelativePath: String { get }
  var sourceImageRelativePath: String { get }
  var geometry: Geometry? { get }
  var background: NSColor? { get }
  var removeAlpha: Bool { get }
}
