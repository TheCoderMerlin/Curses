public class ColorPair {
    private let colors = Colors.shared

    public let name : String
    public let foreground : Color
    public let background : Color

    // Creates a new, named pair
    public init(name:String, foreground:Color, background:Color) {
        self.name = name
        self.foreground = foreground
        self.background = background

        colors.addPair(name:name, foregroundName:foreground.name, backgroundName:background.name)
    }

    public init(name:String) {
        let (foregroundName, backgroundName) = colors.pair(name:name)
        let foregroundColor = Color(name:foregroundName)
        let backgroundColor = Color(name:backgroundName)
        self.name = name
        self.foreground = foregroundColor
        self.background = backgroundColor
    }

    public func on() {
        colors.turnPairOn(pairName:name)
    }

    public func off() {
        colors.turnPairOff(pairName:name)
    }
}
