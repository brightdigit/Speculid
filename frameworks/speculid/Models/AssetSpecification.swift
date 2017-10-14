import Foundation

public struct AssetSpecification: AssetSpecificationProtocol {
  public let idiom: ImageIdiom
  public let scale: CGFloat?
  public let size: CGSize?
  public let filename: String?
}
