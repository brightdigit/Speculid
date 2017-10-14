@available(*, deprecated: 2.0.0)
public enum ApplicationPath: String {
  case inkscape,
    convert

  public static let values: [ApplicationPath] = [.inkscape, .convert]
}
