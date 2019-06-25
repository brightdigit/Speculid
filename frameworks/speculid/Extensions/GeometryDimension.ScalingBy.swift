import CairoSVG

extension GeometryDimension {
  func scalingBy(_ scale: CGFloat) -> GeometryDimension {
    return GeometryDimension(value: value * scale, dimension: dimension)
  }
}
