public class Screen {


    private let curses = Curses.shared
    
    public static let shared = Screen()
    private let standardWindow : Window

    // Explictly disable clients from creating objects of this class
    private init() {
        standardWindow = Window()
    }

    // ============================== API ==============================
    public var window : Window {
        return standardWindow
    }
    
    public func startUp(handler:CursesHandlerProtocol? = nil) {
        curses.startUp(handler:handler)
    }

    public func shutDown() {
        curses.shutDown()
    }

    public func wait() {
        curses.wait()
    }

}
