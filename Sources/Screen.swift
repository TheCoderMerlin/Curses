public class Screen {


    private let curses = Curses.shared
    
    public static let shared = Screen()
    public let cursor = Cursor.shared

    // Explictly disable clients from creating objects of this class
    private init() {
    }

    // ============================== API ==============================
    public func startUp(handler:CursesHandlerProtocol? = nil) {
        curses.startUp(handler:handler)
    }

    public func shutDown() {
        curses.shutDown()
    }

    public func wait() {
        curses.wait()
    }

    public func refresh() {
        curses.refresh()
    }

    public func clear() {
        curses.clear()
    }

    public func clearToEndOfLine() {
        curses.clearToEndOfLine()
    }

    public var size : Size {
        return curses.screenSize()
    }

    public func write(_ string:String) {
        curses.write(string)
    }

    public func write(_ character:Character) {
        write(String(character))
    }

    public func draw(_ rect:Rect) {
        precondition(rect.size.width >= 2, "Unable to draw a Rect that is less than width of 2.")
        precondition(rect.size.height >= 2, "Unable to draw a Rect that is less than height of 2.")

        // Determine corners
        let topLeftCorner = BoxCharacter(top:false, left:false, bottom:true, right:true).thickCharacter
        let topRightCorner = BoxCharacter(top:false, left:true, bottom:true, right:false).thickCharacter
        let bottomLeftCorner = BoxCharacter(top:true, left:false, bottom:false, right:true).thickCharacter
        let bottomRightCorner = BoxCharacter(top:true, left:true, bottom:false, right:false).thickCharacter

        // Determine horizontal
        let horizontal = BoxCharacter(top:false, left:true, bottom:false, right:true).thickCharacter
        let vertical = BoxCharacter(top:true, left:false, bottom:true, right:false).thickCharacter

        // Determine top line
        var topLine = String(topLeftCorner)
        topLine += String(repeating:horizontal, count:rect.size.width - 2)
        topLine += String(topRightCorner)

        // Determine bottom line
        var bottomLine = String(bottomLeftCorner)
        bottomLine += String(repeating:horizontal, count:rect.size.width - 2)
        bottomLine += String(bottomRightCorner)

        // We'll restore the cursor to its starting position when we're done
        cursor.pushPosition()
        let left = cursor.position.x
        let right = left + rect.size.width - 1
        let top = cursor.position.y
        let bottom = top + rect.size.height - 1

        // Write the top line
        write(topLine)

        // Write the body
        for offsetY in 1 ..< rect.size.height - 1 {
            cursor.position = Point(x:left, y:top + offsetY)
            write(String(vertical))

            cursor.position = Point(x:right, y:top + offsetY)
            write(String(vertical))
        }

        // Write the bottom line
        cursor.position = Point(x:left, y:bottom)
        write(bottomLine)

        // Restore the cursor
        cursor.popPosition()
        
        
    }
}
