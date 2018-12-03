public class Cursor {

    private let curses = Curses.shared
    private unowned let window:Window
    private var positionStack = [Point]()

    internal init(window:Window) {
        self.window = window
    }

    // ============================== API ==============================
    public var position : Point {
        get {
            return curses.cursorPosition(windowHandle:window.windowHandle)
        }
        set(newPosition) {
            curses.move(windowHandle:window.windowHandle, to:newPosition)
        }
    }

    public func set(style : CursorStyle) {
        curses.setCursorStyle(style)
    }

    public func pushPosition() {
        positionStack.append(position)
    }

    public func pushPosition(newPosition:Point) {
        positionStack.append(position)
        position = newPosition
    }

    public func popPosition() {
        guard let oldPosition = positionStack.popLast() else {
            fatalError("Cursor position stack is empty; unable to popPosition()")
        }
        position = oldPosition
    }
    
}
