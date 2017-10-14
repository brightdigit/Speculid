public protocol ImageConversionTaskProtocol {
  func start(callback: @escaping (Error?) -> Void)
}
