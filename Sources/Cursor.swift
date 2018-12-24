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
