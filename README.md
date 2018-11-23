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

