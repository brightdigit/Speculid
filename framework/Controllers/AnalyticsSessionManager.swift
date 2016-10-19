//
//  AnalyticsSessionManager.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

public struct AnalyticsSessionManager: AnalyticsSessionManagerProtocol {
  #if DEBUG && false
  public static let defaultBaseUrl = URL(string: "https://www.google-analytics.com/debug/collect")!
  #else
  public static let defaultBaseUrl = URL(string: "https://www.google-analytics.com/collect")!
  #endif
  
  public let baseUrl : URL
  public let timeoutInterval: TimeInterval = 5
  public let session: URLSession
  
  public static func createSession (withDelegate delegate: URLSessionDelegate? = nil, inQueue queue: OperationQueue? = nil, withUserAgent userAgent: String? = nil) -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    //configuration.httpAdditionalHeaders =
    configuration.httpMaximumConnectionsPerHost = 1
    if let userAgent = userAgent {
      configuration.httpAdditionalHeaders = ["User-Agent" : userAgent]
    }
    return URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
  }
  
  public init (baseUrl : URL? = nil) {
    self.baseUrl = baseUrl ?? AnalyticsSessionManager.defaultBaseUrl
    self.session = AnalyticsSessionManager.createSession(withDelegate: nil, inQueue: nil, withUserAgent: nil)
    
    
  }
  
  public func send(_ parameters: AnalyticsParameterDictionary) {    
    let semaphore = DispatchSemaphore(value: 0)
    var request = URLRequest(url: self.baseUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timeoutInterval)
    let parameterString = parameters.map { "\($0.key.rawValue)=\(String(describing: $0.value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"}.joined(separator: "&")
    
    request.httpBody = parameterString.data(using: .utf8)
    request.httpMethod = "POST"
    
    let dataTask = self.session.dataTask(with: request, completionHandler: { (data, result, error) in
      semaphore.signal()
    })
    
    dataTask.resume()
    semaphore.wait()
  }
}
