//
//  AnalyticsSessionManager.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//
import Foundation

public struct AnalyticsSessionManager: AnalyticsSessionManagerProtocol {
  #if DEBUG
    public static let defaultBaseUrl = URL(string: "https://www.google-analytics.com/debug/collect")!
  #else
    public static let defaultBaseUrl = URL(string: "https://www.google-analytics.com/collect")!
  #endif

  public let baseUrl: URL
  public let timeoutInterval: TimeInterval = 5
  public let session: URLSession

  public static func createSession(withDelegate delegate: URLSessionDelegate? = nil, inQueue queue: OperationQueue? = nil, withUserAgent userAgent: String? = nil) -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    // configuration.httpAdditionalHeaders =
    configuration.httpMaximumConnectionsPerHost = 1
    if let userAgent = userAgent {
      configuration.httpAdditionalHeaders = ["User-Agent": userAgent]
    }
    return URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
  }

  public init(baseUrl: URL? = nil) {
    self.baseUrl = baseUrl ?? AnalyticsSessionManager.defaultBaseUrl
    session = AnalyticsSessionManager.createSession(withDelegate: nil, inQueue: nil, withUserAgent: nil)
  }

  public func send(_ parameters: AnalyticsParameterDictionary) {
    let semaphore = DispatchSemaphore(value: 0)
    var request = URLRequest(url: baseUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
    let parameterString = parameters.map { "\($0.key.rawValue)=\(String(describing: $0.value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }.joined(separator: "&")

    request.httpBody = parameterString.data(using: .utf8)
    request.httpMethod = "POST"

    let dataTask = session.dataTask(with: request, completionHandler: { data, _, _ in
      if let data = data {
        #if DEBUG
          if let text = String(data: data, encoding: .utf8) {
            debugPrint(text)
          }
        #endif
      }
      semaphore.signal()
    })

    dataTask.resume()
    semaphore.wait()
  }
}
