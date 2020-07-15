import AppKit
import CairoSVG
import Foundation
/**
 MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
 UnableToScanHexValue:      "Scan hex error"
 MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
 */
public enum UIColorInputError: Error {
  case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}

extension NSColor {
  /**
   The shorthand three-digit hexadecimal representation of color.
   #RGB defines to the color #RRGGBB.

   - parameter hex3: Three-digit hexadecimal value.
   - parameter alpha: 0.0 - 1.0. The default is 1.0.
   */
  public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
    let divisor = CGFloat(15)
    let red = CGFloat((hex3 & 0xF00) >> 8) / divisor
    let green = CGFloat((hex3 & 0x0F0) >> 4) / divisor
    let blue = CGFloat(hex3 & 0x00F) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /**
   The shorthand four-digit hexadecimal representation of color with alpha.
   #RGBA defines to the color #RRGGBBAA.

   - parameter hex4: Four-digit hexadecimal value.
   */
  public convenience init(hex4: UInt16) {
    let divisor = CGFloat(15)
    let red = CGFloat((hex4 & 0xF000) >> 12) / divisor
    let green = CGFloat((hex4 & 0x0F00) >> 8) / divisor
    let blue = CGFloat((hex4 & 0x00F0) >> 4) / divisor
    let alpha = CGFloat(hex4 & 0x000F) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /**
   The six-digit hexadecimal representation of color of the form #RRGGBB.

   - parameter hex6: Six-digit hexadecimal value.
   */
  public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
    let divisor = CGFloat(255)
    let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
    let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
    let blue = CGFloat(hex6 & 0x0000FF) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /**
   The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.

   - parameter hex8: Eight-digit hexadecimal value.
   */
  public convenience init(hex8: UInt32) {
    let divisor = CGFloat(255)
    let red = CGFloat((hex8 & 0xFF00_0000) >> 24) / divisor
    let green = CGFloat((hex8 & 0x00FF_0000) >> 16) / divisor
    let blue = CGFloat((hex8 & 0x0000_FF00) >> 8) / divisor
    let alpha = CGFloat(hex8 & 0x0000_00FF) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /**
   The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.

   - parameter rgba: String value.
   */
  public convenience init(rgba_throws rgba: String) throws {
    guard rgba.hasPrefix("#") else {
      throw UIColorInputError.missingHashMarkAsPrefix
    }

    let index = rgba.index(rgba.startIndex, offsetBy: 1)
    let hexString = rgba[index...]
    var hexValue: UInt32 = 0

    guard Scanner(string: String(hexString)).scanHexInt32(&hexValue) else {
      throw UIColorInputError.unableToScanHexValue
    }

    switch hexString.count {
    case 3:
      self.init(hex3: UInt16(hexValue))
    case 4:
      self.init(hex4: UInt16(hexValue))
    case 6:
      self.init(hex6: hexValue)
    case 8:
      self.init(hex8: hexValue)
    default:
      throw UIColorInputError.mismatchedHexStringLength
    }
  }

  /**
   The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.

   - parameter rgba: String value.
   */
  public convenience init?(_ rgba: String, defaultColor: NSColor = NSColor.clear) {
    guard let color = try? NSColor(rgba_throws: rgba) else {
      self.init(cgColor: defaultColor.cgColor)
      return
    }
    self.init(cgColor: color.cgColor)
  }

  /**
   Hex string of a UIColor instance.

   - parameter includeAlpha: Whether the alpha should be included.
   */
  // swiftlint:disable identifier_name
  public func hexString(_ includeAlpha: Bool = true) -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)

    if includeAlpha {
      return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    } else {
      return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
  }
  // swiftlint:enable identifier_name
}

extension NSColor: CairoColorProtocol {
  public var red: Double {
    Double(redComponent)
  }

  public var green: Double {
    Double(greenComponent)
  }

  public var blue: Double {
    Double(blueComponent)
  }
}

extension String {
  /**
   Convert argb string to rgba string.
   */
  public func argb2rgba() -> String? {
    guard hasPrefix("#") else {
      return nil
    }

    let index = self.index(startIndex, offsetBy: 1)
    let hexString = self[index...]
    switch hexString.count {
    case 4:
      return "#"
        + hexString.substring(from: self.index(startIndex, offsetBy: 1))
        + hexString.substring(to: self.index(startIndex, offsetBy: 1))
    case 8:
      return "#"
        + hexString.substring(from: self.index(startIndex, offsetBy: 2))
        + hexString.substring(to: self.index(startIndex, offsetBy: 2))
    default:
      return nil
    }
  }
}
