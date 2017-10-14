import Foundation

@objc
public protocol ServiceProtocol {
  func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback: @escaping ((NSError?) -> Void))
}
