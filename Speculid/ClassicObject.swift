import Combine
import Foundation
import SpeculidKit
import SwiftUI

class ClassicObject: ObservableObject {
  @Published var url: URL?
  @Published var geometryValue: Float = 0.0
  @Published var assetDirectoryRelativePath: String = ""
  @Published var sourceImageRelativePath: String = ""
  @Published var removeAlpha: Bool = false
  @Published var backgroundColor: Color = .white
  @Published var resizeOption = ResizeOption.none.rawValue
  @Published var addBackground: Bool = false

  @Published var document: ClassicDocument

  var cancellables = [AnyCancellable]()
  var assetDirectoryURL: URL? {
    url?.appendingPathComponent(assetDirectoryRelativePath)
  }

  var sourceImageURL: URL? {
    url?.appendingPathComponent(sourceImageRelativePath)
  }

  var isAppIcon: Bool {
    assetDirectoryRelativePath.lowercased().hasSuffix(".appiconset")
  }

  var isImageSet: Bool {
    assetDirectoryRelativePath.lowercased().hasSuffix(".imageset")
  }

  init(url: URL?, document: ClassicDocument) {
    self.url = url
    self.document = document

    assetDirectoryRelativePath = self.document.assetDirectoryRelativePath
    sourceImageRelativePath = self.document.sourceImageRelativePath
    addBackground = self.document.background != nil
    backgroundColor = self.document.background.map(Color.init) ?? .clear
    geometryValue = self.document.geometry?.value ?? 0.0
    resizeOption = ResizeOption(geometryType: self.document.geometry?.dimension).rawValue
    removeAlpha = self.document.removeAlpha

    let nscolorPub = $addBackground.combineLatest($backgroundColor) {
      $0 ? NSColor($1) : nil
    }

    let geoPub = $resizeOption.map(ResizeOption.init(rawValue:)).combineLatest($geometryValue) { (option, value) -> Geometry? in
      switch option {
      case .some(.width):
        return Geometry(value: value, dimension: .width)
      case .some(.height):
        return Geometry(value: value, dimension: .height)
      default:
        return nil
      }
    }

    assign($assetDirectoryRelativePath, documentProperty: \.assetDirectoryRelativePath)
    assign($sourceImageRelativePath, documentProperty: \.sourceImageRelativePath)
    assign($removeAlpha, documentProperty: \.removeAlpha)
    assign(nscolorPub, documentProperty: \.background)
    assign(geoPub, documentProperty: \.geometry)
    assign($url, documentProperty: \.url)
  }

  func assign<PublisherType: Publisher, ValueType>(_ publisher: PublisherType, documentProperty: WritableKeyPath<ClassicDocument, ValueType>) where PublisherType.Output == ValueType, PublisherType.Failure == Never {
    publisher.sink { value in
      self.document[keyPath: documentProperty] = value
    }.store(in: &cancellables)
  }
}
