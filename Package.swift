// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name:  "Curses",
  products: [
    .library(name: "Curses", targets: ["Curses"]),
  ], 
  dependencies: [
    .package(url:  "../CNCURSES", from: "0.0.0"),
  ],
  targets: [
    .target(
      name:"Curses",
      path:"Sources"),
  ]
)
/*
let package = Package(
  name: "DeckOfPlayingCards",
  products: [
    .library(name: "DeckOfPlayingCards", targets: ["DeckOfPlayingCards"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/example-package-fisheryates.git", from: "2.0.0"),
    .package(url: "https://github.com/apple/example-package-playingcard.git", from: "3.0.0"),
  ],
  targets: [
    .target(
      name: "DeckOfPlayingCards",
      dependencies: ["FisherYates", "PlayingCard"]),
    .testTarget(
      name: "DeckOfPlayingCardsTests",
      dependencies: ["DeckOfPlayingCards"]),
  ]
)
*/
