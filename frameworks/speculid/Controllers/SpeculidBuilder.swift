import Foundation

// TODO: Separate into Files
public typealias ImageConversionPair = (image: AssetSpecificationProtocol, conversion: Result<ImageConversionTaskProtocol>?)
public typealias ImageConversionDictionary = [String: ImageConversionPair]

public extension SpeculidDocumentProtocol {
  public var sourceImageURL: URL {
    return url.deletingLastPathComponent().appendingPathComponent(specificationsFile.sourceImageRelativePath)
  }
  public func destinationName(forImage image: AssetSpecificationProtocol) -> String {
    if let filename = image.filename {
      return filename
    } else if let scale = image.scale {
      if let size = image.size {
        return
          sourceImageURL.deletingPathExtension().appendingPathExtension("\(size.width.cleanValue)x\(size.height.cleanValue)@\(scale.cleanValue)x~\(image.idiom.rawValue).png").lastPathComponent
      } else {
        return sourceImageURL.deletingPathExtension().appendingPathExtension("\(scale.cleanValue)x~\(image.idiom.rawValue).png").lastPathComponent
      }
    } else {
      return sourceImageURL.deletingPathExtension().appendingPathExtension("pdf").lastPathComponent
    }
  }

  public func destinationURL(forImage image: AssetSpecificationProtocol) -> URL {
    return url.deletingLastPathComponent().appendingPathComponent(specificationsFile.assetDirectoryRelativePath, isDirectory: true).appendingPathComponent(destinationName(forImage: image))
  }
}

public struct SpeculidBuilder: SpeculidBuilderProtocol {
  public let tracker: AnalyticsTrackerProtocol?
  public let configuration: SpeculidConfigurationProtocol
  public let imageSpecificationBuilder: SpeculidImageSpecificationBuilderProtocol

  public func build(document: SpeculidDocumentProtocol, callback: @escaping ((Error?) -> Void)) {
    let imageSpecifications: [ImageSpecification]
    do {
      imageSpecifications = try document.asset.images.map { (asset) -> ImageSpecification in
        return try self.imageSpecificationBuilder.imageSpecification(forURL: document.destinationURL(forImage: asset), withSpecifications: document.specificationsFile, andAsset: asset)
      }
    } catch let error {
      return callback(error)
    }
    Application.current.service.exportImageAtURL(document.sourceImageURL, toSpecifications: imageSpecifications, callback)
  }
}

public extension SpeculidBuilderProtocol {
  @available(*, deprecated: 2.0.0)
  func build(document: SpeculidDocumentProtocol) -> Error? {
    var result: Error?
    let semaphone = DispatchSemaphore(value: 0)
    build(document: document) { error in
      result = error
      semaphone.signal()
    }
    semaphone.wait()
    return result
  }
}
