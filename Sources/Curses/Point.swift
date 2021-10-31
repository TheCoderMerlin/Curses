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

public struct Point {
    public let x : Int
    public let y : Int

    public init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }

    public func offsetBy(xOffset:Int, yOffset:Int) -> Point {
        return Point(x: x+xOffset, y:y+yOffset)
    }
}
