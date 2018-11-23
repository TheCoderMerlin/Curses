// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name:  "Curses",
  products: [
    .library(name: "Curses", targets: ["Curses"]),
  ], 
  dependencies: [
    .package(url:  "https://github.com/TangoGolfDigital/CNCURSES.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name:"Curses",
      path:"Sources"),
  ]
)
