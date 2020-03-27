import Foundation

// TODO: Separate into Files
public typealias ImageConversionPair = (image: AssetSpecificationProtocol, conversion: Result<ImageConversionTaskProtocol>?)
public typealias ImageConversionDictionary = [String: ImageConversionPair]

public extension SpeculidDocumentProtocol {
  var sourceImageURL: URL {
    url.deletingLastPathComponent().appendingPathComponent(specificationsFile.sourceImageRelativePath)
  }
  func destinationName(forImage image: AssetSpecificationProtocol) -> String {
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

  @available(*, unavailable)
  func destinationURL(forImage image: AssetSpecificationProtocol) -> URL {
    url.deletingLastPathComponent().appendingPathComponent(specificationsFile.assetDirectoryRelativePath, isDirectory: true).appendingPathComponent(destinationName(forImage: image))
  }

  func destinationURL(forFileName fileName: String) -> URL {
    url.deletingLastPathComponent().appendingPathComponent(specificationsFile.assetDirectoryRelativePath, isDirectory: true).appendingPathComponent(fileName)
  }
  // destinationFileNames
}

public struct SpeculidBuilder: SpeculidBuilderProtocol {
  public let tracker: AnalyticsTrackerProtocol?
  public let configuration: SpeculidConfigurationProtocol
  public let imageSpecificationBuilder: SpeculidImageSpecificationBuilderProtocol

  public func build(document: SpeculidDocumentProtocol, callback: @escaping ((Error?) -> Void)) {
    let imageSpecifications: [ImageSpecification]

    let destinationFileNames = document.assetFile.document.images.map {
      asset in
      (asset, document.destinationName(forImage: asset))
    }
    do {
      imageSpecifications = try destinationFileNames.map { (asset, fileName) -> ImageSpecification in
        try self.imageSpecificationBuilder.imageSpecification(forURL: document.destinationURL(forFileName: fileName), withSpecifications: document.specificationsFile, andAsset: asset)
      }
    } catch {
      return callback(error)
    }
    Application.current.service.exportImageAtURL(document.sourceImageURL, toSpecifications: imageSpecifications) {
      error in
      if let error = error {
        callback(error)
        return
      }
      let mode = self.configuration.mode
      guard case let .command(args) = mode else {
        callback(error)
        return
      }
      guard case let .process(_, true) = args else {
        callback(error)
        return
      }
      let items = destinationFileNames.map(
        AssetCatalogItem.init
      )
      Application.current.service.updateAssetCatalogAtURL(document.assetFile.url, withItems: items, callback)
    }
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

  func build(documents: [SpeculidDocumentProtocol]) -> Error? {
    var errors = [Error]()
    let group = DispatchGroup()
    let errorQueue = DispatchQueue(label: "errors", qos: .default, attributes: .concurrent)
    let buildQueue = DispatchQueue(label: "builder", qos: .userInitiated, attributes: .concurrent)
    for document in documents {
      group.enter()
      buildQueue.async {
        self.build(document: document) { errorOpt in
          if let error = errorOpt {
            errorQueue.async(group: nil, qos: .default, flags: .barrier) {
              errors.append(error)
              group.leave()
            }
          } else {
            group.leave()
          }
        }
      }
    }

    group.wait()
    return ArrayError.error(for: errors)
  }
}
