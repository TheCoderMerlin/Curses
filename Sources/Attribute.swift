import CNCURSES

public class Attribute {
    internal let value : Int

    internal init(value:Int) {
        self.value = value
    }

    // Standard attributes
    static public let normal     = Attribute(value:Curses.attributeNormal)
    static public let standout   = Attribute(value:Curses.attributeStandout)
    static public let underline  = Attribute(value:Curses.attributeUnderline)
    static public let reverse    = Attribute(value:Curses.attributeReverse)
    static public let blink      = Attribute(value:Curses.attributeBlink)
    static public let dim        = Attribute(value:Curses.attributeDim)
    static public let bold       = Attribute(value:Curses.attributeBold)
    static public let invisible  = Attribute(value:Curses.attributeInvisible)
}
