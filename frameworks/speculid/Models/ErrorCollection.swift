import Cocoa

public class ErrorCollection: NSError {
  public let errors: [NSError]

  public init?(errors: [NSError]) {
    guard errors.count > 0 else {
      return nil
    }
    self.errors = errors
    super.init(domain: Bundle(for: type(of: self)).bundleIdentifier!, code: 800, userInfo: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    guard let errors = aDecoder.decodeObject(forKey: "errors") as? [NSError] else {
      return nil
    }
    self.errors = errors
    super.init(coder: aDecoder)
  }

  public override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(errors, forKey: "errors")
  }
}
