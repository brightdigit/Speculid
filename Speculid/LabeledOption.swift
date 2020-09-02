import Foundation

protocol LabeledOption: RawRepresentable, Equatable, Identifiable where RawValue == Int {
  static var mappedValues: [String] { get }
  var label: String { get }
  init(rawValue: RawValue, label: String)
}

extension LabeledOption {
  var id: Int {
    return rawValue
  }

  static func allValues() -> [Self] {
    mappedValues.enumerated().compactMap {
      Self(rawValue: $0.offset, label: $0.element)
    }
  }

  init?(rawValue: RawValue) {
    self.init(rawValue: rawValue, label: Self.mappedValues[rawValue])
  }
}
