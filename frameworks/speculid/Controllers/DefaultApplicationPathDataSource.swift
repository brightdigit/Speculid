import Foundation

@available(*, deprecated: 2.0.0)
public struct DefaultApplicationPathDataSource: ApplicationPathDataSource {
  public func applicationPaths(_ closure: @escaping (ApplicationPathDictionary) -> Void) {
    var applicationPaths = ApplicationPathDictionary()
    for pair in DefaultApplicationPathDataSource.defaultPaths {
      if let url = FileManager.default.url(ifExistsAtPath: pair.value) {
        applicationPaths[pair.key] = url
      }
    }
    closure(applicationPaths)
  }

  public static let defaultPaths: [ApplicationPath: String] = [.inkscape: "/usr/local/bin/inkscape", .convert: "/usr/local/bin/convert"]
}
