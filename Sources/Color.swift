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

public class Color {
    internal let index : Int
    public internal(set) var red : Int     // Value in thousandths
    public internal(set) var green : Int   // Value in thousandths
    public internal(set) var blue : Int    // Value in thousandths

    // Creates a new color
    internal init(index:Int, red:Int, green:Int, blue:Int) {
        self.index = index
        self.red = red
        self.green = green
        self.blue = blue
    }

    // Retrieves an existing color by index
    internal init(index:Int) {
        self.index = index
        (self.red, self.green, self.blue) = Curses.shared.getColor(index:index)
    }

    // Standard colors
    public enum StandardColor : String, CaseIterable {
        case black
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white
    }

    static public func standard(_ standardName:StandardColor) -> Color {
        switch (standardName) {
        case .black:    return Color.black
        case .red:      return Color.red
        case .green:    return Color.green
        case .yellow:   return Color.yellow
        case .blue:     return Color.blue
        case .magenta:  return Color.magenta
        case .cyan:     return Color.cyan
        case .white:    return Color.white
        }
    }

    static public let black : Color = {
        return Color(index:0)
    }()

    static public let red : Color = {
        return Color(index:1)
    }()

    static public let green : Color = {
        return Color(index:2)
    }()

    static public let yellow : Color = {
        return Color(index:3)
    }()

    static public let blue : Color = {
        return Color(index:4)
    }()

    static public let magenta : Color = {
        return Color(index:5)
    }()

    static public let cyan : Color = {
        return Color(index:6)
    }()

    static public let white : Color = {
        return Color(index:7)
    }()


}
