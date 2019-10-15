import Foundation

extension String {
  public func firstMatchGroups(regex: NSRegularExpression) -> [String]? {
    let range = NSRange(0 ..< count)

    guard let result = regex.firstMatch(in: self, options: [], range: range) else {
      return nil
    }
    return (0 ..< result.numberOfRanges).compactMap { (index) -> String? in
      guard let range = Range(result.range(at: index), in: self) else {
        return nil
      }
      return String(self[range])
    }
  }
}
