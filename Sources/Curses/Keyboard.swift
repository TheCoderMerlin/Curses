/*
Curses - ncurses object library for Swift
Copyright (C) 2018 CoderMerlin.com

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

    public func setBufferingOn() {
        curses.setKeyboardBufferingMode(.bufferingIsOn)
    }
    
    public func setBufferingOff() {
        curses.setKeyboardBufferingMode(.bufferingIsOff)
    }
    
    public func setBufferingDelayed(tenthsOfSecond:Int) {
        curses.setKeyboardBufferingMode(.halfDelay(tenthsOfSecond:tenthsOfSecond))
    }
    
}
