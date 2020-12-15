import ArgumentParser
import AssetLib
import Foundation
import SpeculidKit

extension URL {
  func relativePath(from base: URL) -> String? {
    // Ensure that both URLs represent files:
    guard isFileURL, base.isFileURL else {
      return nil
    }

    // Remove/replace "." and "..", make paths absolute:
    let destComponents = standardized.pathComponents
    let baseComponents = base.standardized.pathComponents

    // Find number of common path components:
    var index = 0
    while index < destComponents.count, index < baseComponents.count,
      destComponents[index] == baseComponents[index] {
      index += 1
    }

    // Build relative path:
    var relComponents = Array(repeating: "..", count: baseComponents.count - index)
    relComponents.append(contentsOf: destComponents[index...])
    return relComponents.joined(separator: "/")
  }
}

struct Speculid: ParsableCommand {
  static var configuration = CommandConfiguration(
    subcommands: [Process.self, Initialize.self],
    defaultSubcommand: Process.self
  )
}

extension Speculid {
  struct Initialize: ParsableCommand {
    @Option
    var assetDirectory: String

    @Option
    var sourceImage: String

    @Argument
    var destination: String

    func run() throws {
      let assetDirectoryURL = URL(fileURLWithPath: assetDirectory)
      let sourceImageFileURL = URL(fileURLWithPath: sourceImage)
      let destinationSpecFileURL = URL(fileURLWithPath: destination)

      let decoder = JSONDecoder()

      let contentsJSON = assetDirectoryURL.appendingPathComponent("Contents.json")
      let contentsData = try Data(contentsOf: contentsJSON)
      let setDocument = try decoder.decode(AssetSpecificationDocument.self, from: contentsData)

      let encoder = JSONEncoder()
      let outputFormatting: JSONEncoder.OutputFormatting
      if #available(OSX 10.15, *) {
        outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
      } else {
        outputFormatting = [.prettyPrinted]
      }
      encoder.outputFormatting = outputFormatting

      var file = SpeculidMutableSpecificationsFile(source: SpeculidSpecificationsFile())
      file.assetDirectoryRelativePath = assetDirectoryURL.relativePath(from: destinationSpecFileURL.deletingLastPathComponent())!
      file.sourceImageRelativePath = sourceImageFileURL.relativePath(from: destinationSpecFileURL.deletingLastPathComponent())!

      let data = try encoder.encode(SpeculidSpecificationsFile(source: file))
      try data.write(to: destinationSpecFileURL)
    }
  }

  struct Process: ParsableCommand {
    @Argument
    var file: String = ""

    init() {}

    func run() throws {
      let url = URL(fileURLWithPath: file)
      let document = try SpeculidDocument(url: url, decoder: .init())
      let service = ServiceObject()
      let imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
      let imageSpecs = try document.assetFile.document.images.map {
        try imageSpecificationBuilder.imageSpecification(
          forURL: document.destinationURL(
            forFileName: $0.filename ?? document.destinationName(forImage: $0)),
          withSpecifications: document.specificationsFile,
          andAsset: $0
        )
      }
      var result: Result<Void, Error>?
      DispatchQueue.global(qos: .userInitiated).async {
        service.exportImageAtURL(document.sourceImageURL, toSpecifications: imageSpecs) {
          result = $0.map(Result<Void, Error>.failure) ?? .success(())
        }
      }
      while result == nil {
        RunLoop.main.run(until: .distantPast)
      }

      try result!.get()
    }
  }
}

Speculid.main()
