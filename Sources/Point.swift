public struct Point {
    public let x : Int
    public let y : Int

    public init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }

    public func offsetBy(xOffset:Int, yOffset:Int) -> Point {
        return Point(x: x+xOffset, y:y+yOffset)
    }
}
