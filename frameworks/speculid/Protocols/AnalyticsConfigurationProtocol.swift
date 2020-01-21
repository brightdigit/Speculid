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
  var parameters: AnalyticsParameterDictionary {
    var dictionary = customParameters

    let mainParameters: AnalyticsParameterDictionary = [
      .trackingId: trackingIdentifier,
      .clientId: clientIdentifier,
      .version: version,
      .applicationName: applicationName,
      .applicationVersion: applicationVersion
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
