import Foundation

extension NSNumber {
  // CGFloat -> NSNumber
  private convenience init(doubleOrFloat: Double) {
    self.init(value: doubleOrFloat)
  }

  private convenience init(doubleOrFloat: Float) {
    self.init(value: doubleOrFloat)
  }

  convenience init(cgFloat: CGFloat) {
    self.init(doubleOrFloat: cgFloat.native)
  }

  // NSNumber -> CGFloat
  private func doubleOrFloatValue() -> Double {
    doubleValue
  }

  private func doubleOrFloatValue() -> Float {
    floatValue
  }

  var cgFloatValue: CGFloat {
    CGFloat(floatLiteral: doubleOrFloatValue())
  }
}
