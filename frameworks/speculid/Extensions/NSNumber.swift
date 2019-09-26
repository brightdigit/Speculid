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
    return doubleValue
  }
  private func doubleOrFloatValue() -> Float {
    return floatValue
  }
  var cgFloatValue: CGFloat {
    return CGFloat(floatLiteral: doubleOrFloatValue())
  }
}
