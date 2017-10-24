@available(*, deprecated: 2.0.0)
public protocol ImageConversionTaskProtocol {
  func start(callback: @escaping (Error?) -> Void)
}
