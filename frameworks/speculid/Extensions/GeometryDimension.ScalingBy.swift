import CairoSVG

extension GeometryDimension {
  func scalingBy(_ scale: CGFloat) -> GeometryDimension {
    GeometryDimension(value: value * scale, dimension: dimension)
  }
}
