@testable import CairoSVG
import XCTest

extension NSColor: CairoColorProtocol {
  public var red: Double {
    return Double(redComponent)
  }

  public var green: Double {
    return Double(greenComponent)
  }

  public var blue: Double {
    return Double(blueComponent)
  }
}
class ImageFile: NSObject, ImageFileProtocol {
  let url: URL

  let format: ImageFileFormat

  init(url: URL, fileFormat: ImageFileFormat) {
    self.url = url
    format = fileFormat
    super.init()
  }
}

class ImageSpecification: NSObject, ImageSpecificationProtocol {
  let file: ImageFileProtocol

  let geometry: GeometryDimension

  let removeAlphaChannel: Bool

  let backgroundColor: CairoColorProtocol?

  init(file: ImageFileProtocol, geometry: GeometryDimension, removeAlphaChannel: Bool, backgroundColor: CairoColorProtocol?) {
    self.file = file
    self.geometry = geometry
    self.removeAlphaChannel = removeAlphaChannel
    self.backgroundColor = backgroundColor
    super.init()
  }
}

class CairoSVGTests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let expectedWidth: CGFloat = 90.0
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "geometry", withExtension: "svg")!
    let srcImageFile = ImageFile(url: url, fileFormat: .svg)
    // swiftlint:disable:next force_try
    let imageHandle = try! ImageHandleBuilder.shared.imageHandle(fromFile: srcImageFile)
    let destDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let destImageFile = ImageFile(url: destDirURL.appendingPathComponent(UUID().uuidString), fileFormat: .png)
    let specs = ImageSpecification(file: destImageFile, geometry: GeometryDimension(value: expectedWidth, dimension: .width), removeAlphaChannel: true, backgroundColor: NSColor.cyan)
    // swiftlint:disable:next force_try
    try! CairoInterface.exportImage(imageHandle, withSpecification: specs)
    XCTAssert(FileManager.default.fileExists(atPath: destImageFile.url.path))
    let image = NSImage(byReferencing: destImageFile.url)
    XCTAssertEqual(image.size.width, expectedWidth)
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
