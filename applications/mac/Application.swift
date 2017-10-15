import Cocoa
import Speculid

open class Application: Speculid.Application {
  open override func finishLaunching() {
    let interface = NSXPCInterface(with: ServiceProtocol.self)
    let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")

    connection.remoteObjectInterface = interface
    connection.resume()

    if let service = connection.remoteObjectProxy as? ServiceProtocol,
      let speculidDocuments = Bundle.main.urls(forResourcesWithExtension: "speculid", subdirectory: nil)?.flatMap({ SpeculidDocument(url: $0) }) {
      for document in speculidDocuments {
        let exportSpecifications = document.images.flatMap({ (assetSpecs) -> ImageSpecification? in

          let geometry: Geometry
          if let size = assetSpecs.size {
            geometry = Geometry(value: GeometryValue.width(Int(size.width * (assetSpecs.scale ?? 1.0))))
            // CGSize(width: size.width * (assetSpecs.scale ?? 1.0), height: size.height * (assetSpecs.scale ?? 1.0))
          } else if let geometryValue = document.specifications.geometry?.value {

            //            let dimension: String
            //            let length: CGFloat
            //            switch geometryValue {
            //            case .Width(let value):
            //              dimension = "-w"
            //              length = CGFloat(value) * scale
            //            case .Height(let value):
            //              dimension = "-h"
            //              length = CGFloat(value) * scale
            //            }
            //            arguments.append(contentsOf: [dimension,"\(Int(length))", specifications.sourceImageURL.absoluteURL.path])
            geometry = Geometry(value: geometryValue * (assetSpecs.scale ?? 1.0))

          } else {
            return nil
          }
          let url = URL(fileURLWithPath: document.specifications.destination(forImage: assetSpecs))
          guard let file = ImageFile(url: url) else {
            return nil
          }

          return ImageSpecification(file: file, geometryDimension: geometry)

        })
        service.exportImageAtURL(document.specifications.sourceImageURL, toSpecifications: exportSpecifications, { _ in

        })
      }
    }

    //
    //    if let url = Bundle.main.url(forResource: "layers", withExtension: "svg"), let service = connection.remoteObjectProxy as? ServiceProtocol{
    //      let exportSpecifications = [32,64,128,256].map { (width) -> ImageSpecification in
    //        let file = ImageFile(url: Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("layers.\(width).png"), fileFormat: FileFormat.png)
    //        return ImageSpecification(file: file, geometryDimension: Geometry(value: .width(width)), removeAlphaChannel: true, backgroundColor: NSColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
    //      }
    //
    //    }
    super.finishLaunching()
  }
}
