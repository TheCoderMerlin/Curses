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

public class Attribute {
    internal let value : Int

    internal init(value:Int) {
        self.value = value
    }

    // Standard attributes
    static public let normal     = Attribute(value:Curses.attributeNormal)
    static public let standout   = Attribute(value:Curses.attributeStandout)
    static public let underline  = Attribute(value:Curses.attributeUnderline)
    static public let reverse    = Attribute(value:Curses.attributeReverse)
    static public let blink      = Attribute(value:Curses.attributeBlink)
    static public let dim        = Attribute(value:Curses.attributeDim)
    static public let bold       = Attribute(value:Curses.attributeBold)
    static public let invisible  = Attribute(value:Curses.attributeInvisible)
}
