import Foundation

public struct UnknownConversionError: Error {
  let document: SpeculidDocumentProtocol

  public init(fromDocument document: SpeculidDocumentProtocol) {
    self.document = document
  }
}
