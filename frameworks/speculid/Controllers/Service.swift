import Cocoa
import CairoSVG

public final class Service: NSObject, ServiceProtocol {
  public func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback: @escaping ((NSError?) -> Void)) {

    let imageFile = ImageFile(url: url, fileFormat: .svg)
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
