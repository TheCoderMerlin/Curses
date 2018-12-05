import CNCURSES

public class Window {
    private let curses = Curses.shared
    
    let windowHandle : UnsafeMutablePointer<WINDOW>
    public let name : String
    private var _cursor : Cursor! = nil

    public var cursor : Cursor {
        return _cursor
    }
    
    // Creates the default window covering the entire screen
    internal init() {
        windowHandle = stdscr
        name = "*stdscr*"
        _cursor = Cursor(window:self)
        curses.setKeyPadMode(windowHandle:windowHandle)
    }

    internal init(name:String, position:Point, size:Size) {
        self.windowHandle = curses.newWindow(position:position, size:size)
        self.name = name
        self._cursor = Cursor(window:self)
        curses.setKeyPadMode(windowHandle:windowHandle)
    }

    public func refresh() {
        curses.refresh(windowHandle:windowHandle)
    }

    public func clear() {
        curses.clear(windowHandle:windowHandle)
    }

    public func clearToEndOfLine() {
        curses.clearToEndOfLine(windowHandle:windowHandle)
    }

    public func clearToBottomOfWindow() {
        curses.clearToBottomOfWindow(windowHandle:windowHandle)
    }

    public var size : Size {
        return curses.screenSize(windowHandle:windowHandle)
    }

    public func write(_ string:String) {
        curses.write(windowHandle:windowHandle, string:string)
    }

    public func write(_ character:Character) {
        write(String(character))
    }

    public func turnOn(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeOn(windowHandle:windowHandle, attributeValue:attributeValue)
    }

    public func turnOff(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeOff(windowHandle:windowHandle, attributeValue:attributeValue)
    }

    public func setAs(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeSet(windowHandle:windowHandle, attributeValue:attributeValue)
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
