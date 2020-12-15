import Foundation

public enum Result<T> {
  case error(Error)
  case success(T)
}
