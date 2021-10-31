// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name:  "Curses",
  products: [
    .library(name: "Curses",
             type: .dynamic,
             targets: ["Curses"]),
  ], 
  targets: [
    .target(
      name:"Curses",
      dependencies: ["ncurses"]),
    .systemLibrary(name: "ncurses")
  ]
)
