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

public class BoxCharacter {
    // DO NOT CHANGE THE ORDER OF THESE CASES
    // We rely on the ordering to look up the correct values
    public enum Spokes : UInt8 {
        case none
        case right
        case bottom
        case bottomRight
        
        case left
        case leftRight
        case leftBottom
        case leftBottomRight
        
        case top
        case topRight
        case topBottom
        case topBottomRight
        
        case topLeft
        case topLeftRight
        case topLeftBottom
        case all
    } // enum

    public enum SingleSpoke {
        case top
        case left
        case bottom
        case right
    }
    public typealias SingleSpokes = Set<SingleSpoke>

    public static let thickNone             : Character = " "
    public static let thickRight            : Character = "\u{257A}"  // ╺
    public static let thickBottom           : Character = "\u{257B}"  // ╻
    public static let thickBottomRight      : Character = "\u{250F}"  // ┏
    
    public static let thickLeft             : Character = "\u{2578}"  // ╸
    public static let thickLeftRight        : Character = "\u{2501}"  // ━
    public static let thickLeftBottom       : Character = "\u{2513}"  // ┓
    public static let thickLeftBottomRight  : Character = "\u{2533}"  // ┳
    
    public static let thickTop              : Character = "\u{2579}"  // ╹
    public static let thickTopRight         : Character = "\u{2517}"  // ┗
    public static let thickTopBottom        : Character = "\u{2503}"  // ┃
    public static let thickTopBottomRight   : Character = "\u{2523}"  // ┣
    
    public static let thickTopLeft          : Character = "\u{251B}"  // ┛
    public static let thickTopLeftRight     : Character = "\u{253B}"  // ┻
    public static let thickTopLeftBottom    : Character = "\u{252B}"  // ┫
    public static let thickAll              : Character = "\u{254B}"  // ╋

    // DO NOT CHANGE THE ORDER OF THESE ELEMENTS
    // We rely on the ordering to look up the correct values
    private static let thick = [thickNone, thickRight, thickBottom, thickBottomRight,
                                thickLeft, thickLeftRight, thickLeftBottom, thickLeftBottomRight,
                                thickTop, thickTopRight, thickTopBottom, thickTopBottomRight,
                                thickTopLeft, thickTopLeftRight, thickTopLeftBottom, thickAll]


    public private(set) var spokes : Spokes
    public var thickCharacter : Character {
        return BoxCharacter.thick[Int(spokes.rawValue)]
    }


    private static func indexFromIndividualSpokes(top:Bool, left:Bool, bottom:Bool, right:Bool) -> UInt8 {
        // Calculate the raw value
        var rawValue : UInt8 =  0
        rawValue += top     ? 1 : 0
        rawValue *= 2
        
        rawValue += left    ? 1 : 0
        rawValue *= 2
        
        rawValue += bottom  ? 1 : 0
        rawValue *= 2
        
        rawValue += right   ? 1 : 0
        return rawValue
    }
    
    public init(top:Bool, left:Bool, bottom:Bool, right:Bool) {
        let index = BoxCharacter.indexFromIndividualSpokes(top:top, left:left, bottom:bottom, right:right)
        precondition(index < BoxCharacter.thick.count, "Specified index (\(index)) was invalid because it exceeds count of thick array.")
        guard let spokes = Spokes(rawValue: index) else {
            fatalError("Specified index (\(index)) was invalid because Spokes could not be found")
        }
        self.spokes = spokes
    }

    public convenience init(withSpokes singleSpokes:SingleSpokes) {
        let top    = singleSpokes.contains(.top)
        let left   = singleSpokes.contains(.left)
        let bottom = singleSpokes.contains(.bottom)
        let right  = singleSpokes.contains(.right)
        self.init(top:top, left:left, bottom:bottom, right:right)
    }
}
