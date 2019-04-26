/*
Curses - ncurses object library for Swift
Copyright (C) 2018 Tango Golf Digital, LLC

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
        case halfDelay(tenthsOfSecond:Int)
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
        case .halfDelay(let tenthsOfSecond):
            CNCURSES.halfdelay(Int32(tenthsOfSecond))
        }
    }

    func setScroll(windowHandle:UnsafeMutablePointer<WINDOW>, enabled:Bool) {
        CNCURSES.scrollok(windowHandle, enabled)
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

    func backgroundSet(windowHandle:UnsafeMutablePointer<WINDOW>, attributeValue:Int, character:Character) {
        let unicodeScalars = character.unicodeScalars
        let ascii = UInt(unicodeScalars[unicodeScalars.startIndex].value)
        let attributeAndCharacter : UInt = UInt(attributeValue) | ascii
        CNCURSES.wbkgd(windowHandle, attributeAndCharacter)
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

    static let attributeNormal : Int = {
        return 0
    }()

    static let attributeStandout : Int = {
        return Int(ncursesBits(mask:1, shift:8))
    }()

    static let attributeUnderline : Int = {
        return Int(ncursesBits(mask:1, shift:9))
    }()

    static let attributeReverse : Int = {
        return Int(ncursesBits(mask:1, shift:10))
    }()

    static let attributeBlink : Int = {
        return Int(ncursesBits(mask:1, shift:11))
    }()

    static let attributeDim : Int = {
        return Int(ncursesBits(mask:1, shift:12))
    }()

    static let attributeBold : Int = {
        return Int(ncursesBits(mask:1, shift:13))
    }()

    static let attributeInvisible : Int = {
        return Int(ncursesBits(mask:1, shift:15))
    }()



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


    /* These attributes are not imported into swift and are duplicated here 
     #define NCURSES_ATTR_SHIFT       8
     #define NCURSES_BITS(mask,shift) (NCURSES_CAST(chtype,(mask)) << ((shift) + NCURSES_ATTR_SHIFT))

     #define A_NORMAL	(1UL - 1UL)
     #define A_ATTRIBUTES	NCURSES_BITS(~(1UL - 1UL),0)
     #define A_CHARTEXT	(NCURSES_BITS(1UL,0) - 1UL)
     #define A_COLOR		NCURSES_BITS(((1UL) << 8) - 1UL,0)
     #define A_STANDOUT	NCURSES_BITS(1UL,8)
     #define A_UNDERLINE	NCURSES_BITS(1UL,9)
     #define A_REVERSE	NCURSES_BITS(1UL,10)
     #define A_BLINK		NCURSES_BITS(1UL,11)
     #define A_DIM		NCURSES_BITS(1UL,12)
     #define A_BOLD		NCURSES_BITS(1UL,13)
     #define A_ALTCHARSET	NCURSES_BITS(1UL,14)
     #define A_INVIS		NCURSES_BITS(1UL,15)
     #define A_PROTECT	NCURSES_BITS(1UL,16)
     #define A_HORIZONTAL	NCURSES_BITS(1UL,17)
     #define A_LEFT		NCURSES_BITS(1UL,18)
     #define A_LOW		NCURSES_BITS(1UL,19)
     #define A_RIGHT		NCURSES_BITS(1UL,20)
     #define A_TOP		NCURSES_BITS(1UL,21)
     #define A_VERTICAL	NCURSES_BITS(1UL,22)

     #if 1
     #define A_ITALIC	NCURSES_BITS(1UL,23)	/* ncurses extension */
     #endif
     */

    private static func ncursesBits(mask:UInt32, shift:UInt32) -> UInt32 {
        return mask << (shift + 8)
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
