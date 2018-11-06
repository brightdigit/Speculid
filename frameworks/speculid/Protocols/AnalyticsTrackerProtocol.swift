import Foundation

public protocol AnalyticsTrackerProtocol {
  func track(time: TimeInterval, withCategory category: String, withVariable variable: String, withLabel label: String?)

  func track(event: AnalyticsEventProtocol)

  func track(error: Error, isFatal: Bool)
}

public extension AnalyticsTrackerProtocol {
  func track(exception: NSException) {
    track(error: exception, isFatal: true)
  }
}

extension NSException: Error {}
