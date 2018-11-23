public class Cursor {

    internal static let shared = Cursor()
    private let curses = Curses.shared
    private var positionStack = [Point]()

    // Explicitly disable clients from creating objects of this class
    private init() {
    }

    // ============================== API ==============================
    public var position : Point {
        get {
            return curses.cursorPosition()
        }
        set(newPosition) {
            curses.move(to:newPosition)
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
