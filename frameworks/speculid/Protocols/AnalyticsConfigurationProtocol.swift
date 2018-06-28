import Foundation

public protocol AnalyticsConfigurationProtocol {
  var applicationVersion: String { get }
  var applicationName: String { get }
  var trackingIdentifier: String { get }
  var clientIdentifier: String { get }
  var version: Int { get }
  var userLanguage: String? { get }
  var customParameters: AnalyticsParameterDictionary { get }
}

public extension AnalyticsConfigurationProtocol {
  public var parameters: AnalyticsParameterDictionary {
    var dictionary = customParameters

    let mainParameters: AnalyticsParameterDictionary = [
      .trackingId: self.trackingIdentifier,
      .clientId: self.clientIdentifier,
      .version: self.version,
      .applicationName: self.applicationName,
      .applicationVersion: self.applicationVersion
    ]
    mainParameters.forEach {
      dictionary[$0.0] = $0.1
    }

    if let userLanguage = self.userLanguage {
      dictionary[.userLanguage] = userLanguage
    }

    return dictionary
  }
}
