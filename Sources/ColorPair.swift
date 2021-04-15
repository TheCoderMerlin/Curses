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

public class ColorPair : Attribute {
    internal let index : Int
    public let foreground : Color
    public let background : Color

    // Creates a new, named pair
    internal init(index:Int, foreground:Color, background:Color) {
        self.index = index
        self.foreground = foreground
        self.background = background
        
        super.init(value:Curses.shared.colorAttributeValue(pairIndex:index))
    }

    internal init(index:Int) {
        self.index = index

        let (foregroundIndex, backgroundIndex) = Curses.shared.getColorPair(index:index)
        self.foreground = Color(index:foregroundIndex)
        self.background = Color(index:backgroundIndex)
        
        super.init(value:Curses.shared.colorAttributeValue(pairIndex:index))
    }

    static public let defaultPair : ColorPair = {
        return ColorPair(index:0)
    }()

}
