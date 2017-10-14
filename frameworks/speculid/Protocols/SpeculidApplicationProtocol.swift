import Foundation

public protocol SpeculidApplicationProtocol {
  func document(url: URL) -> SpeculidDocumentProtocol?
  var builder: SpeculidBuilderProtocol { get }
  // var version : Version { get }
}
