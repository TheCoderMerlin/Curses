public class ColorPair : Attribute {
    internal let index : Int
    public let foreground : Color
    public let background : Color

    // Creates a new, named pair
    internal init(index:Int, foreground:Color, background:Color) {
        self.index = index
        self.foreground = foreground
        self.background = background
        
        super.init(value:Curses.shared.colorAttributeValue(pairIndex:index))
    }

    internal init(index:Int) {
        self.index = index

        let (foregroundIndex, backgroundIndex) = Curses.shared.getColorPair(index:index)
        self.foreground = Color(index:foregroundIndex)
        self.background = Color(index:backgroundIndex)
        
        super.init(value:Curses.shared.colorAttributeValue(pairIndex:index))
    }

    static public let defaultPair : ColorPair = {
        return ColorPair(index:0)
    }()

}
