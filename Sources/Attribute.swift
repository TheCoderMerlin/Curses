import CNCURSES

public class Attribute {
    internal let value : Int

    internal init(value:Int) {
        self.value = value
    }

    // Standard attributes
    static public let bold = Attribute(value:Curses.attributeBold)
}
