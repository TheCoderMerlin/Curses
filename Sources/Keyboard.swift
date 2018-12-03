public class Keyboard {

    public static let shared = Keyboard()
    private let curses = Curses.shared

    // Explicitly disable clients from creating object of this class
    private init() {
    }

    // ============================== API ==============================
    public func getKey(window:Window) -> Key {
        return curses.getKey(windowHandle:window.windowHandle)
    }

    
}
