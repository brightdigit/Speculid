import Foundation

public struct SpeculidApplication: SpeculidApplicationProtocol {
  let configuration: SpeculidConfigurationProtocol
  let tracker: AnalyticsTrackerProtocol?

  public func document(url: URL) -> SpeculidDocumentProtocol? {
    return SpeculidDocument(url: url, configuration: configuration)
  }

  public var builder: SpeculidBuilderProtocol {
    return SpeculidBuilder(tracker: tracker, configuration: configuration)
  }

  //  public var version : Version {
  //    return Speculid.version
  //  }
}
