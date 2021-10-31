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

    public func newWindow(position:Point, size:Size) -> Window {
        return Window(position:position, size:size)
    }

    public func wait() {
        curses.wait()
    }

}
