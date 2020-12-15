import Foundation

public protocol AnalyticsEventProtocol {
  var category: String { get }
  var action: String { get }
  var label: String? { get }
  var value: Int? { get }
}
