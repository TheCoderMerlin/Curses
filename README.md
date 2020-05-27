# Curses
Curses provides a Swift object wrapper for the curses programming library for Linux (tested on Ubuntu 16.04, 18.04)

## What is Curses?
Curses enables better-looking, text-based (console) applications in a terminal-agnostic manner.
This wrapper provides access to some of this functionality via Swift objects.  Current functionality suppports:
* Windows
* Cursor manipulation
* Text attribute manipulation
* Color manipulation
* Keyboard access
* Box drawing

![Sample Screen](/images/sampleScreen.png?raw=true "Sample Screen")

## Usage

### Library
In order to use the library, include this resource as a dependency in Package.swift
```swift
// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name:  "myApplication",
  dependencies: [
    .package(url: "https://github.com/TheCoderMerlin/Curses", from: "1.0.0"),
  ],
  targets: [
    .target(
      name:"myApplication",
      dependencies:["Curses"],
      path: "Sources"),
  ]
)
```

### Opening/Closing the library
To begin using the library, import Curses, access the shared *Screen* object, and invoke *startUp()*.
```swift
import Curses

let screen = Screen.shared
screen.startUp()
```

When done with the library, be sure to cleanly exit by invoking *shutDown()*.
```swift
screen.shutDown()
```

### Interrupt Handler
A common paradigm is to continue running the application until interrupted with ^C.  An easy way to acheive this is as follows:
```swift
// Define an interrupt handler
let screen = Screen.shared

class Handler : CursesHandlerProtocol {
    func interruptHandler() {
        screen.shutDown()
        print("Good bye!")
        exit(0)
    }

    func windowChangedHandler() {
    }
}

// Start up
screen.startUp(handler:Handler())

// Do some fun stuff

// Wait forever, or until the user presses ^C
screen.wait()
```
### Windows
Provide shortcut access to the single instance of the screen's window
It's OK to use this instance OR to create separate windows located on the screen
but it's generally not a good practice to mix and match.

To use only the main window:
```swift
let mainWindow = screen.window
```

To use only separate windows:
```swift
let firstWindow = screen.newWindow(position:Point(x:10, y:20), size:Size(width:100, height:20))
let secondWindow = screen.newWindow(position:Point(x:120, y:10), size:Size(width:100, height:20))
```

### Writing to the Console
Writing will occur at the current cursor position using the currently active attributes
```swift
mainWindow.write("Hello, world!")
```

### Flushing changes to the Console
**IMPORTANT:** Changes will not be visible on the console until a *refresh()* is invoked
```swift
mainWindow.refresh()
```
### Enabling Scrolling
mainWindow.setScroll(enabled:true) 

### Moving the Cursor
```swift
// Move the cursor to an absolute position
let cursor = mainWindow.cursor
cursor.position = Point(x:10, y:10)

// Temporarily move the cursor to a new position
cursor.pushPosition(newPosition:Point(x:0, y:0))
mainWindow.write("Cursor is at: \(cursor.position)")
cursor.popPosition()
```
### Using Attributes
Attributes may be turned on by having the window *turnOn()* the attribute. 
It's polite to *turnOff()* the attribute when done.
To set a particular attribute without regard to the current attributes at that
location, execute *setTo()*.

```swift
// Display text in various attributes
mainWindow.turnOn(Attribute.normal)
mainWindow.write("Normal")
mainWindow.turnOff(Attribute.normal)
mainWindow.write(" ")                                                                                                                          

mainWindow.turnOn(Attribute.standout)
mainWindow.write("Standout")
mainWindow.turnOff(Attribute.standout)
mainWindow.write(" ")

mainWindow.turnOn(Attribute.underline)
mainWindow.write("Underline")
mainWindow.turnOff(Attribute.underline)
mainWindow.write(" ")

mainWindow.turnOn(Attribute.reverse)
mainWindow.write("Reverse")
mainWindow.turnOff(Attribute.reverse)
mainWindow.write(" ")

mainWindow.turnOn(Attribute.blink)
mainWindow.write("Blink")
mainWindow.turnOff(Attribute.blink)
mainWindow.write(" ")

mainWindow.turnOn(Attribute.dim)
mainWindow.write("Dim")
mainWindow.turnOff(Attribute.dim)
mainWindow.write(" ")

mainWindow.turnOn(Attribute.bold)
mainWindow.write("Bold")
mainWindow.turnOff(Attribute.bold)
```

### Using Color
Before using color, Colors needs to be started up.
It's important to ensure that the terminal supports colors before proceeding.
Colors may only be started up AFTER Curses is started up.
```swift
screen.startUp(handler:handler)

let colors = Colors.shared
precondition(colors.areSupported, "This terminal doesn't support colors")
colors.startUp()
```
Standard colors can be accessed by using an enum:
```swift
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
```
Colors are always used in pairs, one for the foreground and one for the background.
To write to the screen using red as the foreground and white as the background,
we create a pair, turn it on, and then politely turn it off when done.
```swift
let red = Color.standard(.red)
let white = Color.standard(.white)
let redOnWhite = colors.newPair(foreground:red, background:white)

mainWindow.cursor.position = Point(x:0, y:0)
mainWindow.turnOn(redOnWhite)
mainWindow.write("RED ON WHITE")
mainWindow.turnOff(redOnWhite)
```
We can create a chart of color pairs and display them:
```swift
// Find the length of the longest color name
// We'll use this for spacing the columns
let maxColorNameLength = Color.StandardColor.allCases.map {$0.rawValue.count}.max()!
let xSpaceBetweenNames = 3
// We'll start the display at the third row 
var row = 3
// Iterate through all of the foreground and background colors
for foregroundColor in Color.StandardColor.allCases {
    var column = 1
    for backgroundColor in Color.StandardColor.allCases { 
        // Create a new color pair
        // Note that the number of color pairs is limited so this may not work on all terminals
        precondition(colors.pairCount + 1 < colors.maxPairCount, "Unable to create more color pairs.")
        let pair = colors.newPair(foreground:Color.standard(foregroundColor), background:Color.standard(backgroundColor)) 
        
        // Turn on the color attribute
        // It's polite to turn off what we turned on (below)
        mainWindow.turnOn(pair)
        // Position the cursor
        mainWindow.cursor.position = Point(x: column * (maxColorNameLength + xSpaceBetweenNames), y:row)
        // Write the color name
        mainWindow.write(backgroundColor.rawValue)
        // Turn off the color attribute
        mainWindow.turnOff(pair) 
        column += 1 
    }
    row += 1
}
```
Custom colors can be created by specifying red, green, and blue values
in the range of 0 through 1000, provided the terminal supports this functionality. 
If supported, there are a limited number of "slots" available .
```swift
precondition(colors.customColorsAreSupported, "Custom colors are not supported.")
precondition(colors.colorCount + 1 < colors.maxColorCount, "No more slots available for custom colors.")
let orange = colors.newColor(red:1000, green:500, blue:0)
precondition(colors.pairCount + 1 < colors.maxPairCount, "Unable to create more color pairs.")
let orangeOnBlack = colors.newPair(foreground:orange, background:Color.standard(.black)) 

mainWindow.turnOn(orangeOnBlack) 
mainWindow.write("Orange") 
mainWindow.turnOff(orangeOnBlack)  
```

### Changing the Background
```swift
let cyan = Color.standard(.cyan)
let black = Color.standard(.black)
let cyanOnBlack = colors.newPair(foreground:black, background:cyan)

mainWindow.backgroundSet(attribute:cyanOnBlack)
mainWindow.clear()
mainWindow.write("Hello, World!")
mainWindow.refresh()
```

### Using the keyboard

```swift
let keyboard = Keyboard.shared

while true {
    let key = keyboard.getKey(window:mainWindow)

    var youPressed : String
    if key.keyType == .isCharacter {
        youPressed = "You pressed: \(key.character!)"
    } else if key.keyType == .isControl {
        youPressed = "You pressed: CONTROL-\(key.control!)"
    } else {
        var label : String
        switch (key.keyType) {
        case .arrowDown: label = "Down"
        case .arrowUp: label = "Up"
        case .arrowRight: label = "Right"
        case .arrowLeft: label = "Left"
 
        case .function1: label = "F1"
        case .function2: label = "F2"
        case .function3: label = "F3"
        case .function4: label = "F4"

        case .enter:     label = "ENTER"
 
        default: label = "Other"
        }
        youPressed = "You pressed a special key: \(label)"
    }
    mainWindow.cursor.position = Point(x:1, y:2)
    mainWindow.write(youPressed)
    mainWindow.clearToEndOfLine()
    mainWindow.refresh()
}
```

### Getting text from a field
```swift
let cyan = Color.standard(.cyan)
let black = Color.standard(.black)
let cyanOnBlack = colors.newPair(foreground:black, background:cyan)
let string = mainWindow.getStringFromTextField(at:Point(x:10, y:10), maxCharacters:10, fieldColorPair:cyanOnBlack)
```
