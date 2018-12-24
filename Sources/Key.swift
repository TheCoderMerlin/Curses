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

public struct Key {
    private static let down             = KEY_DOWN	     /* down-arrow key */
    private static let up               = KEY_UP	     /* up-arrow key */
    private static let left  	        = KEY_LEFT    	     /* left-arrow key */
    private static let right            = KEY_RIGHT   	     /* right-arrow key */

    private static let backspace        = KEY_BACKSPACE	     /* backspace key */

    private static let F1               = KEY_F0 +  1        /* Function keys */
    private static let F2               = KEY_F0 +  2
    private static let F3               = KEY_F0 +  3
    private static let F4               = KEY_F0 +  4
    private static let F5               = KEY_F0 +  5
    private static let F6               = KEY_F0 +  6
    private static let F7               = KEY_F0 +  7
    private static let F8               = KEY_F0 +  8
    private static let F9               = KEY_F0 +  9
    private static let F10              = KEY_F0 + 10
    private static let F11              = KEY_F0 + 11
    private static let F12              = KEY_F0 + 12

    private static let enter            = KEY_ENTER

    public enum KeyType {
        // key type
        case isUnknown
        case isControl
        case isCharacter

        // special keys
        case arrowDown
        case arrowUp
        case arrowLeft
        case arrowRight

        case backspace

        case function1
        case function2
        case function3
        case function4
        case function5
        case function6
        case function7
        case function8
        case function9
        case function10
        case function11
        case function12

        case enter
    }

    let specialKeyMap = [
      down         : KeyType.arrowDown,
      up           : KeyType.arrowUp,
      left         : KeyType.arrowLeft,
      right        : KeyType.arrowRight,

      backspace    : KeyType.backspace,

      F1           : KeyType.function1,
      F2           : KeyType.function2,
      F3           : KeyType.function3,
      F4           : KeyType.function4,
      F5           : KeyType.function5,
      F6           : KeyType.function6,
      F7           : KeyType.function7,
      F8           : KeyType.function8,
      F9           : KeyType.function9,
      F10          : KeyType.function10,
      F11          : KeyType.function11,
      F12          : KeyType.function12,

      enter        : KeyType.enter
    ]

    // Code and key type are always set
    private let code : Int32
    public let keyType : KeyType

    // Character and control key are set as appropriate
    public let character : Character?
    public let control : UInt8?

    init(code:Int32) {
        self.code = code

        let specialKey = specialKeyMap[code]
        if specialKey != nil {
            // We found a special key so we set the key type accordingingly
            keyType = specialKey!
            character = nil
            control = nil
        } else if (0...31).contains(code) {
            // We found a control key
            keyType = .isControl
            character = nil
            control = UInt8(code)
        } else if (32...127).contains(code) {
            // We found an ascii key
            keyType = .isCharacter
            guard let unicodeScalar =  UnicodeScalar(Int(code)) else {
                fatalError("Expected unicode scalar for code: \(code)")
            }
            
            character = Character(unicodeScalar)
            control = nil
        } else {
            // Unknown
            keyType = .isUnknown
            character = nil
            control = nil
        }
    }



    
      /*    
let KEY_HOME	     = 0o0406		/* home key */


let KEY_DL	     = 0o0510		/* delete-line key */
let KEY_IL	     = 0o0511		/* insert-line key */
let KEY_DC	     = 0o0512		/* delete-character key */
let KEY_IC	     = 0o0513		/* insert-character key */
let KEY_EIC	     = 0o0514		/* sent by rmir or smir in insert mode */
let KEY_CLEAR	= 0o0515		/* clear-screen or erase key */
let KEY_EOS		= 0o0516		/* clear-to-end-of-screen key */
let KEY_EOL		= 0o0517		/* clear-to-end-of-line key */
let KEY_SF		= 0o0520		/* scroll-forward key */
let KEY_SR		= 0o0521		/* scroll-backward key */
let KEY_NPAGE	= 0o0522		/* next-page key */
let KEY_PPAGE	= 0o0523		/* previous-page key */
let KEY_STAB	= 0o0524		/* set-tab key */
let KEY_CTAB	= 0o0525		/* clear-tab key */
let KEY_CATAB	= 0o0526		/* clear-all-tabs key */
let KEY_PRINT	= 0o0532		/* print key */
let KEY_LL		= 0o0533		/* lower-left key (home down) */
let KEY_A1		= 0o0534		/* upper left of keypad */
let KEY_A3		= 0o0535		/* upper right of keypad */
let KEY_B2		= 0o0536		/* center of keypad */
let KEY_C1		= 0o0537		/* lower left of keypad */
let KEY_C3		= 0o0540		/* lower right of keypad */
let KEY_BTAB	= 0o0541		/* back-tab key */
let KEY_BEG		= 0o0542		/* begin key */
let KEY_CANCEL	= 0o0543		/* cancel key */
let KEY_CLOSE	= 0o0544		/* close key */
let KEY_COMMAND	= 0o0545		/* command key */
let KEY_COPY	= 0o0546		/* copy key */
let KEY_CREATE	= 0o0547		/* create key */
let KEY_END		= 0o0550		/* end key */
let KEY_EXIT	= 0o0551		/* exit key */
let KEY_FIND	= 0o0552		/* find key */
let KEY_HELP	= 0o0553		/* help key */
let KEY_MARK	= 0o0554		/* mark key */
let KEY_MESSAGE	= 0o0555		/* message key */
let KEY_MOVE	= 0o0556		/* move key */
let KEY_NEXT	= 0o0557		/* next key */
let KEY_OPEN	= 0o0560		/* open key */
let KEY_OPTIONS	= 0o0561		/* options key */
let KEY_PREVIOUS	= 0o0562		/* previous key */
let KEY_REDO	= 0o0563		/* redo key */
let KEY_REFERENCE	= 0o0564		/* reference key */
let KEY_REFRESH	= 0o0565		/* refresh key */
let KEY_REPLACE	= 0o0566		/* replace key */
let KEY_RESTART	= 0o0567		/* restart key */
let KEY_RESUME	= 0o0570		/* resume key */
let KEY_SAVE	= 0o0571		/* save key */
let KEY_SBEG	= 0o0572		/* shifted begin key */
let KEY_SCANCEL	= 0o0573		/* shifted cancel key */
let KEY_SCOMMAND	= 0o0574		/* shifted command key */
let KEY_SCOPY	= 0o0575		/* shifted copy key */
let KEY_SCREATE	= 0o0576		/* shifted create key */
let KEY_SDC		= 0o0577		/* shifted delete-character key */
let KEY_SDL		= 0o0600		/* shifted delete-line key */
let KEY_SELECT	= 0o0601		/* select key */
let KEY_SEND	= 0o0602		/* shifted end key */
let KEY_SEOL	= 0o0603		/* shifted clear-to-end-of-line key */
let KEY_SEXIT	= 0o0604		/* shifted exit key */
let KEY_SFIND	= 0o0605		/* shifted find key */
let KEY_SHELP	= 0o0606		/* shifted help key */
let KEY_SHOME	= 0o0607		/* shifted home key */
let KEY_SIC		= 0o0610		/* shifted insert-character key */
let KEY_SLEFT	= 0o0611		/* shifted left-arrow key */
let KEY_SMESSAGE	= 0o0612		/* shifted message key */
let KEY_SMOVE	= 0o0613		/* shifted move key */
let KEY_SNEXT	= 0o0614		/* shifted next key */
let KEY_SOPTIONS	= 0o0615		/* shifted options key */
let KEY_SPREVIOUS	= 0o0616		/* shifted previous key */
let KEY_SPRINT	= 0o0617		/* shifted print key */
let KEY_SREDO	= 0o0620		/* shifted redo key */
let KEY_SREPLACE	= 0o0621		/* shifted replace key */
let KEY_SRIGHT	= 0o0622		/* shifted right-arrow key */
let KEY_SRSUME	= 0o0623		/* shifted resume key */
let KEY_SSAVE	= 0o0624		/* shifted save key */
let KEY_SSUSPEND	= 0o0625		/* shifted suspend key */
let KEY_SUNDO	= 0o0626		/* shifted undo key */
let KEY_SUSPEND	= 0o0627		/* suspend key */
let KEY_UNDO	= 0o0630		/* undo key */
let KEY_MOUSE	= 0o0631		/* Mouse event has occurred */
let KEY_RESIZE	= 0o0632		/* Terminal resize event */
let KEY_EVENT	= 0o0633		/* We were interrupted by an event */
*/

    
}

