public struct Rect {
    public let topLeft : Point
    public let size : Size
    public var bottomRight : Point {
        return Point(x:topLeft.x + size.width - 1,
                     y:topLeft.y + size.height - 1)
    }

    public init(topLeft:Point, size:Size) {
        self.topLeft = topLeft
        self.size = size
    }
}
