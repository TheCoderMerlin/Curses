public class Screen {


    private let curses = Curses.shared
    
    public static let shared = Screen()
    private var standardWindow : Window? = nil

    // Explictly disable clients from creating objects of this class
    private init() {
    }

    // ============================== API ==============================
    public var window : Window {
        precondition(standardWindow != nil, "Screen.window is not available until after startUp")
        return standardWindow!
    }

    public func startUp(handler:CursesHandlerProtocol? = nil) {
        curses.startUp(handler:handler)
        standardWindow = Window()
    }

    public func shutDown() {
        curses.shutDown()
        standardWindow = nil
    }

    public func newWindow(name:String, position:Point, size:Size) -> Window {
        return Window(position:position, size:size)
    }

    public func wait() {
        curses.wait()
    }

}
