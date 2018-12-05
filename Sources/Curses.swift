import CNCURSES


// References:
// http://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html
// http://www.cs.ukzn.ac.za/~hughm/os/notes/ncurses.html
// https://invisible-island.net/ncurses/ncurses-intro.html

// This is a singleton class
internal class Curses {
    // ============================== Singleton Pattern ==============================
    static let shared = Curses()

    
    // ============================== Type ==============================
    enum KeyboardBufferingMode {
        case bufferingIsOn
        case bufferingIsOff
    }
        

    
    // ============================== Variables ==============================

    static var handler : CursesHandlerProtocol? = nil

    var startUpCount = 0
    
    // Explicitly disable clients from creating objects of this class
    private init() {
        // Register signal handlers
        Curses.registerSignalHandlers()
    }
    

    // ============================== Internal API ==============================
    /*
    func reset() {
        CNCURSES.endwin()
        refresh()
        CNCURSES.initscr()
        clear()
    }
    */

    func startUp(handler:CursesHandlerProtocol? = nil) {
        precondition(startUpCount == 0, "Curses is already running.")

        // Store user's handler
        Curses.handler = handler
        

        // Set locale
        setlocale(LC_ALL, "")

        // Initialize curses
        CNCURSES.initscr()
        CNCURSES.noecho()

        startUpCount += 1
    }
    
    func shutDown() {
        precondition(startUpCount == 1, "No instance of Curses is currently running.")

        Curses.handler = nil
        CNCURSES.endwin()

        startUpCount -= 1
    }

    func wait() {
        while true {
            select(0, nil, nil, nil, nil)
        }
    }

    func cursorPosition(windowHandle:UnsafeMutablePointer<WINDOW>) -> Point {
        return getCursorPosition(windowHandle:windowHandle)
    }

    func screenSize(windowHandle:UnsafeMutablePointer<WINDOW>) -> Size {
        return getScreenSize(windowHandle:windowHandle)
    }
    
    func setCursorStyle(_ cursorStyle:CursorStyle) {
        CNCURSES.curs_set(cursorStyle.rawValue)
    }

    func setKeyPadMode(windowHandle:UnsafeMutablePointer<WINDOW>) {
        CNCURSES.keypad(windowHandle, true) // Processes special keys into special codes rather than escape sequences
    }

    func setKeyboardBufferingMode(_ keyboardBufferingMode:KeyboardBufferingMode) {
        switch (keyboardBufferingMode) {
        case .bufferingIsOn :
            CNCURSES.nocbreak()
        case .bufferingIsOff:
            CNCURSES.cbreak()
        }
    }

    func getKey(windowHandle:UnsafeMutablePointer<WINDOW>) -> Key {
        let code =  CNCURSES.wgetch(windowHandle)
        let key = Key(code:code)
        return key
    }

    func newWindow(position:Point, size:Size) -> UnsafeMutablePointer<WINDOW> {
        return CNCURSES.newwin(Int32(size.height), Int32(size.width), Int32(position.y), Int32(position.x))
    }
    
    func refresh(windowHandle:UnsafeMutablePointer<WINDOW>) {
        CNCURSES.wrefresh(windowHandle)
    }

    func clear(windowHandle:UnsafeMutablePointer<WINDOW>) {
        CNCURSES.wclear(windowHandle)
    }

    func clearToEndOfLine(windowHandle:UnsafeMutablePointer<WINDOW>) {
        CNCURSES.wclrtoeol(windowHandle)
    }

    func clearToBottomOfWindow(windowHandle:UnsafeMutablePointer<WINDOW>) {
        CNCURSES.wclrtobot(windowHandle)
    }
    
    func move(windowHandle:UnsafeMutablePointer<WINDOW>, to:Point) {
        CNCURSES.wmove(windowHandle, Int32(to.y), Int32(to.x))
    }

    func write(windowHandle:UnsafeMutablePointer<WINDOW>, string:String) {
        CNCURSES.waddstr(windowHandle, string)
    }

    func attributeOn(windowHandle:UnsafeMutablePointer<WINDOW>, attributeValue:Int) {
        CNCURSES.wattron(windowHandle, Int32(attributeValue))
    }

    func attributeOff(windowHandle:UnsafeMutablePointer<WINDOW>, attributeValue:Int) {
        CNCURSES.wattroff(windowHandle, Int32(attributeValue))
    }

    func attributeSet(windowHandle:UnsafeMutablePointer<WINDOW>, attributeValue:Int) {
        CNCURSES.wattrset(windowHandle, Int32(attributeValue))
    }
    
    var maxColorCount : Int {
        return Int(COLORS)
    }

    var maxColorPairCount : Int {
        return Int(COLOR_PAIRS)
    }

    var colorsAreSupported : Bool {
        return has_colors()
    }

    var customColorsAreSupported : Bool {
        return can_change_color()
    }

    func startColors() {
        if !colorsAreSupported {
            fatalError("Unable to start colors because they are not supported on this terminal.")
        }
        start_color()
    }

    func getColor(index:Int) -> (red:Int, green:Int, blue:Int) {
        var red : Int16 = 0
        var green : Int16 = 0
        var blue : Int16 = 0
        getColorContent(index:Int16(index), red:&red, green:&green, blue:&blue)
        return (red:Int(red), green:Int(green), blue:Int(blue))
    }

    func setColor(index:Int, red:Int, green:Int, blue:Int) {
        init_color(Int16(index), Int16(red), Int16(green), Int16(blue))
    }

    func getColorPair(index:Int) -> (foregroundIndex:Int, backgroundIndex:Int) {
        var foregroundIndex : Int16 = 0
        var backgroundIndex : Int16 = 0
        getColorPair(index:Int16(index), foregroundIndex:&foregroundIndex, backgroundIndex:&backgroundIndex)
        return (foregroundIndex:Int(foregroundIndex), backgroundIndex:Int(backgroundIndex))
    }

    func setColorPair(index:Int, foregroundIndex:Int, backgroundIndex:Int) {
        init_pair(Int16(index), Int16(foregroundIndex), Int16(backgroundIndex))
    }


    func colorAttributeValue(pairIndex:Int) -> Int {
        return Int(COLOR_PAIR(Int32(pairIndex)))
    }


    // ============================== Helper Functions ==============================
    // NB:  This appears to only update after an endwin/refresh/initscr
    private func getScreenSize(windowHandle:UnsafeMutablePointer<WINDOW>) -> Size {
        let width  : Int32 = getmaxx(windowHandle)
        let height : Int32 = getmaxy(windowHandle)
        return Size(width:Int(width), height:Int(height))
    }

    private func getCursorPosition(windowHandle:UnsafeMutablePointer<WINDOW>) -> Point {
        let x : Int32 = getcurx(windowHandle)
        let y : Int32 = getcury(windowHandle)
        return Point(x:Int(x), y:Int(y))
    }

    private func getColorContent(index:Int16, red:inout Int16, green:inout Int16, blue:inout Int16) {
        color_content(index, &red, &green, &blue)
    }

    private func getColorPair(index:Int16, foregroundIndex:inout Int16, backgroundIndex:inout Int16) {
        pair_content(index, &foregroundIndex, &backgroundIndex)
    }


    // ============================== Signal Handler Definitions ==============================
    private enum Signal : Int32 {
        case int = 2
        case winch = 28
    }

    private typealias SignalHandler = __sighandler_t

    private static func trap(signalNumber:Signal, action:@escaping SignalHandler) {
        signal(signalNumber.rawValue, action)
    }

    private static func registerSignalHandlers() {
        // Register signal handlers
        trap(signalNumber:.int) {signal in 
            Curses.interruptHandler(signal)
        }

        trap(signalNumber:.winch) {signal in
            Curses.winchHandler(signal)
        }
    }

    // ============================== Signal Handlers ==============================
    private static func interruptHandler(_ signal:Int32) {
        if let handler = handler {
            handler.interruptHandler()
        }
    }

    private static func winchHandler(_ signal:Int32) {
        if let handler = handler {
            handler.windowChangedHandler()
        }
    }

    
    
}
