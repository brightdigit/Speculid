import Foundation

public enum Result<T> {
  // swiftlint:disable:next identifier_name
  case error(Error)
  // swiftlint:disable:next identifier_name
  case success(T)
}
