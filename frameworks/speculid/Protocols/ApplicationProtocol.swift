import Foundation

public protocol ApplicationProtocol {
  func document(url: URL) -> SpeculidDocumentProtocol?
  var builder: SpeculidBuilderProtocol! { get }
  var service: ServiceProtocol! { get }
  var regularExpressions: RegularExpressionSetProtocol! { get }
  var tracker: AnalyticsTrackerProtocol! { get }
  // var version : Version { get }
}
