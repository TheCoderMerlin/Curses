public class Keyboard {

    public static let shared = Keyboard()
    private let curses = Curses.shared

    // Explicitly disable clients from creating object of this class
    private init() {
    }

    // ============================== API ==============================
    public func getKey() -> Key {
        return curses.getKey()
    }

    
}
