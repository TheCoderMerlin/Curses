# Curses
Curses provides a Swift object wrapper for the curses programming library for Linux (tested on Ubuntu 16.04)

## What is Curses?
Curses enables better-looking, text-based (console) applications in a terminal-agnostic manner.
This wrapper provides access to some of this functionality via Swift objects.  Current functionality suppports:
* Cursor manipulation
* Color manipulation
* Keyboard access
* Box drawing

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
    .package(url: "https://github.com/TangoGolfDigital/Curses.git", from: "0.0.49"),
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
screen.startUp()

// Do some fun stuff

// Wait forever, or until the user presses ^C
screen.wait()
```

### Writing to the Console
Writing will occur at the current cursor position using the currently active attributes
```swift
screen.write("Hello, world!")
```

### Flushing changes to the Console
**IMPORTANT:** Changes will not be visible on the console until a *refresh()* is invoked
```swift
screen.refresh()
```

### Moving the Cursor
```swift
// Move the cursor to an absolute position
let cursor = screen.cursor
cursor.position = Point(x:10, y:10)

// Temporarily move the cursor to a new position
cursor.pushPosition(newPosition:Point(x:0, y:0))
screen.write("Cursor is at: \(cursor.position)")
cursor.popPosition()
```

### Using Color
Colors are always used in pairs, one for the foreground and one for the background.
Before using color, Colors needs to be started up.
```swift
let colors = Colors.shared
colors.startUp()

// Set up standard color pairs on white background
var colorPairs = [ColorPair]()
for colorName in colors.colorNames() {
    colorPairs.append(ColorPair(name:"\(colorName) on white", foreground:Color(name:colorName), background:Color(name:"white")))
}

// Use each of the color pairs on screen
for pairName in colors.pairNames() {
    let colorPair = ColorPair(name:pairName)
    colorPair.on()
    screen.write(colorPair.name)
    colorPair.off()
}

// Refresh
screen.refresh()
```

Custom colors may be defined by specifying red, green, and blue components in the range of 0 ... 1000.

```swift
let orange = Color(name:"orange", red:1000, green:165*3, blue:0)
let black = Color(name:"black")

let orangeOnBlack = ColorPair(name:"orange on black", foreground:orange, background:black)
let blackOnOrange = ColorPair(name:"black on orange", foreground:Color(name:"black"), background:Color(name:"orange"))

orangeOnBlack.on()
screen.write("Orange on Black")
orangeOnBlack.off()

blackOnOrange.on()
screen.write("Black on Orange")

screen.refresh()
```

### Using the keyboard

```swift
let keyboard = Keyboard.shared

while true {
    let key = keyboard.getKey()

    if key.keyType == .isCharacter {
        cursor.position = Point(x:10, y:10)
        screen.write("You pressed: \(key.character!)")
        screen.clearToEndOfLine()
        screen.refresh()
    } else if key.keyType == .isControl {
        cursor.position = Point(x:10, y:15)
        screen.write("You pressed: CONTROL-\(key.control!)")
        screen.clearToEndOfLine()
        screen.refresh()
    } else {
        cursor.position = Point(x:10, y:20)
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
        screen.write("You pressed a special key: \(label)")
        screen.clearToEndOfLine()
        screen.refresh()
    }
}
```
