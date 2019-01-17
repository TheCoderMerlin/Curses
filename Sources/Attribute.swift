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
  
/** 
 The `Attribute` class provides the ability to alter the text attribute
 of the text in a `Window`.  

 Instances of this class may not be initialized by client code.
 Rather, there are several preset constants available.
 The class is also used internally to represent colors.

 Typical usage:
 
 ```
 window.turnOn(Attribute.underline)
 window.write("This text is underlined.")
 window.turnOff(Attribute.underline)
 ```
*/
public class Attribute {
    // value is a raw value of attribute
    internal let value : Int

    internal init(value:Int) {
        self.value = value
    }

    // Normal terminal display (no highlighting)
    static public let normal     = Attribute(value:Curses.attributeNormal)

    // Terminal display with highlighting
    static public let standout   = Attribute(value:Curses.attributeStandout)

    // Text is underlined
    static public let underline  = Attribute(value:Curses.attributeUnderline)

    // Text is reversed
    static public let reverse    = Attribute(value:Curses.attributeReverse)

    // Text blinks
    static public let blink      = Attribute(value:Curses.attributeBlink)

    // Text is dimmed
    static public let dim        = Attribute(value:Curses.attributeDim)

    // Text is bold
    static public let bold       = Attribute(value:Curses.attributeBold)

    // Text is invisible
    static public let invisible  = Attribute(value:Curses.attributeInvisible)
}
