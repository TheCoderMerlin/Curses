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

public class Window {
    private let curses = Curses.shared
    
    let windowHandle : UnsafeMutablePointer<WINDOW>
    private var _cursor : Cursor! = nil

    public var cursor : Cursor {
        return _cursor
    }
    
    // Creates the default window covering the entire screen
    internal init() {
        windowHandle = stdscr
        _cursor = Cursor(window:self)
        curses.setKeyPadMode(windowHandle:windowHandle)
    }

    internal init(position:Point, size:Size) {
        self.windowHandle = curses.newWindow(position:position, size:size)
        self._cursor = Cursor(window:self)
        curses.setKeyPadMode(windowHandle:windowHandle)
    }

    public func setScroll(enabled:Bool) {
        curses.setScroll(windowHandle:windowHandle, enabled:enabled)
    }

    public func refresh() {
        curses.refresh(windowHandle:windowHandle)
    }

    public func clear() {
        curses.clear(windowHandle:windowHandle)
    }

    public func clearToEndOfLine() {
        curses.clearToEndOfLine(windowHandle:windowHandle)
    }

    public func clearToBottomOfWindow() {
        curses.clearToBottomOfWindow(windowHandle:windowHandle)
    }

    public var size : Size {
        return curses.screenSize(windowHandle:windowHandle)
    }

    public func write(_ string:String) {
        curses.write(windowHandle:windowHandle, string:string)
    }

    public func write(_ character:Character) {
        write(String(character))
    }

    public func turnOn(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeOn(windowHandle:windowHandle, attributeValue:attributeValue)
    }

    public func turnOff(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeOff(windowHandle:windowHandle, attributeValue:attributeValue)
    }

    public func setTo(_ attribute:Attribute) {
        let attributeValue = attribute.value
        curses.attributeSet(windowHandle:windowHandle, attributeValue:attributeValue)
    }

    public func draw(_ rect:Rect) {
        precondition(rect.size.width >= 2, "Unable to draw a Rect that is less than width of 2.")
        precondition(rect.size.height >= 2, "Unable to draw a Rect that is less than height of 2.")

        // Determine corners
        let topLeftCorner = BoxCharacter(top:false, left:false, bottom:true, right:true).thickCharacter
        let topRightCorner = BoxCharacter(top:false, left:true, bottom:true, right:false).thickCharacter
        let bottomLeftCorner = BoxCharacter(top:true, left:false, bottom:false, right:true).thickCharacter
        let bottomRightCorner = BoxCharacter(top:true, left:true, bottom:false, right:false).thickCharacter

        // Determine horizontal
        let horizontal = BoxCharacter(top:false, left:true, bottom:false, right:true).thickCharacter
        let vertical = BoxCharacter(top:true, left:false, bottom:true, right:false).thickCharacter

        // Determine top line
        var topLine = String(topLeftCorner)
        topLine += String(repeating:horizontal, count:rect.size.width - 2)
        topLine += String(topRightCorner)

        // Determine bottom line
        var bottomLine = String(bottomLeftCorner)
        bottomLine += String(repeating:horizontal, count:rect.size.width - 2)
        bottomLine += String(bottomRightCorner)

        // We'll restore the cursor to its starting position when we're done
        cursor.pushPosition(newPosition:rect.topLeft)
        let left = rect.topLeft.x
        let right = left + rect.size.width - 1
        let top = rect.topLeft.y
        let bottom = top + rect.size.height - 1

        // Write the top line
        write(topLine)

        // Write the body
        for offsetY in 1 ..< rect.size.height - 1 {
            cursor.position = Point(x:left, y:top + offsetY)
            write(String(vertical))

            cursor.position = Point(x:right, y:top + offsetY)
            write(String(vertical))
        }

        // Write the bottom line
        cursor.position = Point(x:left, y:bottom)
        write(bottomLine)

        // Restore the cursor
        cursor.popPosition()
    }

    // Returns a string as entered by the user, providing for simple editing support using left and right arrows and the backspace
    // key.  The input is collected from a field beginning at the specified position of a maximum length as specified.
    // If a fieldColorPair is specified Colors MUST be active.  The field will then be displayed in the specified colorPair.
    // The function will exit when either TAB or ENTER is pressed
    public func getStringFromTextField(at fieldPosition:Point, maxCharacters:Int, fieldColorPair:ColorPair?) -> String {
        // Access keyboard
        let keyboard = Keyboard.shared
        
        // Save cursor position to be restored later and move cursor to field
        cursor.pushPosition()
        cursor.position = fieldPosition

        // If a fieldColorPair is specified, we turn that color on
        if let fieldColorPair = fieldColorPair {
            turnOn(fieldColorPair)
            let pad = String(repeating:" ", count:maxCharacters)
            write(pad)
            cursor.position = fieldPosition
        }
        
        var string = ""
        var insertionPoint = string.startIndex
        var shouldExit = false
        repeat {
            let key = keyboard.getKey(window:self)
            switch key.keyType {
            case .isCharacter:
                // Update the string
                string.insert(key.character!, at:insertionPoint)

                // Move the insertion point forward
                insertionPoint = string.index(after:insertionPoint)

                // Write the chracter and move the cursor forward
                write(key.character!)

                // Print the remaining characters
                if insertionPoint < string.endIndex {
                    let remainingCharacters = String(string[insertionPoint...])

                    // Write the remaining characters
                    write(remainingCharacters)

                    // Move the cursor back
                    cursor.position = cursor.position.offsetBy(xOffset:-remainingCharacters.count, yOffset:0)
                }
            case .backspace:
                if insertionPoint > string.startIndex {
                    // Move the insertion point backward
                    insertionPoint = string.index(before:insertionPoint)

                    // Update the string
                    string.remove(at:insertionPoint)

                    // Move the cursor backward
                    cursor.position = cursor.position.offsetBy(xOffset:-1, yOffset:0)

                    // Write the string from this point forward in order
                    // to erase what was there previously
                    // The final character printed will be a space to erase
                    // the last character
                    let remainingCharacters = String(string[insertionPoint...])
                    write(remainingCharacters)
                    write(" ")

                    // Move the cursor back again
                    cursor.position = cursor.position.offsetBy(xOffset:-remainingCharacters.count-1, yOffset:0)
                }
            case .arrowLeft:
                if insertionPoint > string.startIndex {
                    // Move the insertion point backward
                    insertionPoint = string.index(before:insertionPoint)

                    // Move the cursor backward
                    cursor.position = cursor.position.offsetBy(xOffset:-1, yOffset:0)
                }
            case .arrowRight:
                if insertionPoint < string.endIndex {
                    // Move the insertion point forward
                    insertionPoint = string.index(after:insertionPoint)

                    // Move the cursor forward
                    cursor.position = cursor.position.offsetBy(xOffset:1, yOffset:0)
                }
            case .isControl:
                let isEnter = key.control! == 10
                let isTab = key.control! == 9
                shouldExit = isEnter || isTab
            default:
                do {}
            }
        } while !shouldExit


        // If a fieldColorPair is specified, we turn that color off
        if let fieldColorPair = fieldColorPair {
            turnOff(fieldColorPair)
        }
        
        // Restore cursor position and return string
        cursor.popPosition()
        return string
    }

}
