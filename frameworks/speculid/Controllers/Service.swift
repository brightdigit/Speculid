import CairoSVG
import Cocoa

public final class Service: NSObject, ServiceProtocol {
  let exportQueue = DispatchQueue(label: "export", qos: .default, attributes: .concurrent)
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
    let errorQueue = DispatchQueue(label: "error", qos: .default, attributes: .concurrent)
    let imageFile = ImageFile(url: url, format: .svg)
    let builtImageHandle: ImageHandle?
    do {
      builtImageHandle = try ImageHandleBuilder.shared.imageHandle(fromFile: imageFile)
    } catch let error as NSError {
      dump(error)
      callback(error)
      return
    }

    guard let imageHandle = builtImageHandle else {
      return
    }

    let group = DispatchGroup()
    var errors = [NSError]()

    for specs in specifications {
      group.enter()
      exportQueue.async(flags: .barrier) {
        do {
          try CairoInterface.exportImage(imageHandle, withSpecification: specs)
        } catch let error as NSError {
          errorQueue.async(flags: .barrier) {
            errors.append(error)
            group.leave()
          }
          return
        }
        group.leave()
      }
    }

    group.notify(queue: .main) {
      callback(ErrorCollection(errors: errors))
    }
  }
}
