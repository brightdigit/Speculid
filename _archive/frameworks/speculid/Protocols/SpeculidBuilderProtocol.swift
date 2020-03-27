public protocol SpeculidBuilderProtocol {
  func build(document: SpeculidDocumentProtocol, callback: @escaping ((Error?) -> Void))
}
