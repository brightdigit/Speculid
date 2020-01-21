import Foundation

// TODO: Separate Files
public enum AnalyticsHitType: String, CustomStringConvertible {
  case timing, event, exception

  public var description: String {
    rawValue
  }
}

public struct AnalyticsEvent: AnalyticsEventProtocol {
  public let category: String
  public let action: String
  public let label: String?
  public let value: Int?

  public init(category: String, action: String, label: String? = nil, value: Int? = nil) {
    self.category = category
    self.action = action
    self.label = label
    self.value = value
  }
}

public struct AnalyticsTracker: AnalyticsTrackerProtocol {
  public func track(error: Error, isFatal: Bool) {
    var parameters = configuration.parameters

    parameters[.hitType] = AnalyticsHitType.exception
    parameters[.exceptionDescription] = error.localizedDescription
    parameters[.exceptionFatal] = isFatal ? 1 : 0

    sessionManager.send(parameters)
  }

  public func track(event: AnalyticsEventProtocol) {
    var parameters = configuration.parameters

    parameters[.hitType] = AnalyticsHitType.event
    parameters[.eventCategory] = event.category
    parameters[.eventAction] = event.action

    if let label = event.label {
      parameters[.eventLabel] = label
    }

    if let value = event.value {
      parameters[.eventValue] = value
    }

    sessionManager.send(parameters)
  }

  let configuration: AnalyticsConfigurationProtocol
  let sessionManager: AnalyticsSessionManagerProtocol

  public func track(time: TimeInterval, withCategory category: String, withVariable variable: String, withLabel label: String?) {
    var parameters = configuration.parameters

    parameters[.hitType] = AnalyticsHitType.timing
    parameters[.userTimingCategory] = category
    parameters[.userTimingVariable] = variable
    parameters[.timing] = Int(round(time * 1000.0))

    if let label = label {
      parameters[.userTimingLabel] = label
    }

    sessionManager.send(parameters)
  }
}
