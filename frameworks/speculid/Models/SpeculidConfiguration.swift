import Foundation

@available(*, deprecated: 2.0.0)
extension FileManager {
  func url(ifExistsAtPath path: String) -> URL? {
    return FileManager.default.fileExists(atPath: path) ? URL(fileURLWithPath: path) : nil
  }
}

public struct SpeculidConfiguration: SpeculidConfigurationProtocol {
  public static let `default` = SpeculidConfiguration()
}
