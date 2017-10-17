import Foundation

public struct SpeculidDocument: SpeculidDocumentProtocol {
  public let specifications: SpeculidSpecificationsProtocol
  public let images: [AssetSpecificationProtocol]

  public init?(url: URL, configuration _: SpeculidConfigurationProtocol? = nil) {

    guard let specifications = SpeculidSpecifications(url: url) else {
      return nil
    }

    guard let contentsJSONData = try? Data(contentsOf: specifications.contentsDirectoryURL.appendingPathComponent("Contents.json")) else {
      return nil
    }

    guard let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String: Any] else {
      return nil
    }

    guard let images = contentsJSON?["images"] as? [[String: String]] else {
      return nil
    }

    self.images = images.flatMap { (dictionary) -> AssetSpecification? in
      let scale: CGFloat?
      let size: CGSize?

      let scaleRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .scale)

      if let scaleString = dictionary["scale"]?.firstMatchGroups(regex: scaleRegex)?[1], let value = Double(scaleString) {
        scale = CGFloat(value)
      } else {
        scale = nil
      }

      guard let idiomString = dictionary["idiom"], let idiom = ImageIdiom(rawValue: idiomString) else {
        return nil
      }

      let sizeRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .size)

      if let dimensionStrings = dictionary["size"]?.firstMatchGroups(regex: sizeRegex), let width = Double(dimensionStrings[1]), let height = Double(dimensionStrings[2]) {
        size = CGSize(width: width, height: height)
      } else {
        size = nil
      }

      let filename = dictionary["filename"]

      return AssetSpecification(idiom: idiom, scale: scale, size: size, filename: filename)
    }

    self.specifications = specifications
  }
}
