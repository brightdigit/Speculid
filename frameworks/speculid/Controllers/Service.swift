import CairoSVG
import Cocoa

public final class Service: NSObject, ServiceProtocol {
  public func updateAssetCatalogAtURL(_ url: URL, withItems items: [AssetCatalogItem], _ callback: @escaping ((NSError?) -> Void)) {
    let document = AssetSpecificationDocument(fromItems: items)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
      let data = try encoder.encode(document)
      try data.write(to: url)
    } catch {
      callback(error as NSError)
      return
    }
    callback(nil)
  }

  public func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback: @escaping ((NSError?) -> Void)) {
    let imageFile = ImageFile(url: url, format: .svg)
    let builtImageHandle: ImageHandle?
    do {
      builtImageHandle = try ImageHandleBuilder.shared.imageHandle(fromFile: imageFile)
    } catch let error as NSError {
      callback(error)
      return
    }

    guard let imageHandle = builtImageHandle else {
      return
    }

    let group = DispatchGroup()
    var errors = [NSError]()

    for specs in specifications {
      DispatchQueue.main.async {
        group.enter()
        do {
          try CairoInterface.exportImage(imageHandle, withSpecification: specs)
        } catch let error as NSError {
          errors.append(error)
        }
        group.leave()
      }
    }

    group.notify(queue: .main) {
      callback(ErrorCollection(errors: errors))
    }
  }
}
