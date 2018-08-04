import Foundation
import SwiftVer

public protocol ApplicationProtocol: VersionProvider {
  func document(url: URL) throws -> SpeculidDocumentProtocol
  var builder: SpeculidBuilderProtocol! { get }
  var service: ServiceProtocol! { get }
  var regularExpressions: RegularExpressionSetProtocol! { get }
  var tracker: AnalyticsTrackerProtocol! { get }
  func quit(_ sender: Any?)
}
