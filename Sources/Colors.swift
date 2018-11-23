public class Colors {

    public static let shared = Colors()
    private let curses = Curses.shared

    // Explicitly disable clients from creating objects of this class
    private init() {
    }

    private var started : Bool = false
    private var colors = [String: Int]()   // Maps a color name to an integer
    private var pairs = [String: Int]()    // Maps a pair name to an integer
    private var inUsePairStack = [String]()  // Tracks colors currently in use

    // ============================== API ==============================
    public func startUp() {
        startIfNecessary()
    }
    
    public var maxColorCount : Int {
        return curses.maxColorCount
    }

    public var maxPairCount : Int {
        return curses.maxColorPairCount
    }

    public var areSupported : Bool {
        return curses.colorsAreSupported
    }

    public var customColorsAreSupported : Bool {
        return curses.customColorsAreSupported
    }

    public func colorNames() -> [String] {
        return Array<String>(colors.keys)
    }

    public func pairNames() -> [String] {
        return Array<String>(pairs.keys)
    }

    // ============================== Helper Functions ==============================
    func startIfNecessary() {
        if !started {
            // Start using colors
            curses.startColors()
            
            // Load first eight pre-defined colors
            colors["black"]     = 0
            colors["red"]       = 1
            colors["green"]     = 2
            colors["yellow"]    = 3
            colors["blue"]      = 4
            colors["magenta"]   = 5
            colors["cyan"]      = 6
            colors["white"]     = 7

            // Add default pair
            pairs["default"]    = 0

            // Remember that we've started
            started = true
        }
    }

    // Returns the color specified by colorName
    func color(name:String) -> (red:Int, green:Int, blue:Int) {
        guard let index = colors[name] else {
            fatalError("The specified name '\(name)' was not found.")
        }
        return curses.getColor(index:index)
    }


    // Inserts the specified color for later use
    // The number of insertions is limited to Colors.count
    func add(name:String, red:Int, green:Int, blue:Int) {
        precondition((0...1000).contains(red), "Red must be in range of 0...1000, not \(red)")
        precondition((0...1000).contains(green), "Green must be in range of 0...1000, not \(green)")
        precondition((0...1000).contains(blue), "Blue must be in range of 0...1000, not \(blue)")
        precondition(colors.count < maxColorCount, "Unable to add more colors, already at maximum \(maxColorCount)")
        precondition(customColorsAreSupported, "Terminal does not support adding colors")
        
        let newColorIndex = colors.count
        curses.setColor(index:newColorIndex, red:red, green:green, blue:blue)
        colors[name] = newColorIndex
    }

    func addPair(name:String, foregroundName:String, backgroundName:String) {
        guard let foregroundIndex = colors[foregroundName] else {
            fatalError("The specified foregroundName '\(foregroundName)' was not found.")
        }
        guard let backgroundIndex = colors[backgroundName] else {
            fatalError("The specified backgroundName '\(backgroundName)' was not found.")
        }
        guard pairs.count < maxPairCount else {
            fatalError("Unable to add more pairs; already at maximum \(maxPairCount)")
        }
        guard pairs[name] == nil else {
            fatalError("The specified pair name '\(name)' already exists.")
        }

        let newPairIndex = pairs.count
        curses.setColorPair(index:newPairIndex, foregroundIndex:foregroundIndex, backgroundIndex:backgroundIndex)
        pairs[name] = newPairIndex
    }

    func turnPairOn(pairName:String) {
        guard let pairIndex = pairs[pairName] else {
            fatalError("The specified pairName '\(pairName)' was not found.") 
        }

        inUsePairStack.append(pairName)
        curses.colorPairAttributeOn(pairIndex:pairIndex)
    }

    func turnPairOff(pairName:String) {
        guard let pairIndex = pairs[pairName] else {
            fatalError("The specified pairName '\(pairName)' was not found.")
        }
        guard let stackPairName = inUsePairStack.popLast() else {
            fatalError("The inUsePairStack is empty; no colorPair was in use previously.")
        }
        guard pairName == stackPairName else {
            fatalError("The specified pairName '\(pairName)' doesn't match the expected pairName '\(stackPairName)'.")
        }

        curses.colorPairAttributeOff(pairIndex:pairIndex)
    }

    // Returns the pair information specified by the name
    func pair(name:String) -> (foregroundName:String, backgroundName:String) {
        guard let index = pairs[name] else {
            fatalError("The specified name of the pair '\(name)' was not found.")
        }
        let (foregroundIndex, backgroundIndex) = curses.getColorPair(index:index)
        let foregroundNames = colors.filter {$0.value == foregroundIndex}.map {$0.key}
        let backgroundNames = colors.filter {$0.value == backgroundIndex}.map {$0.key}
        
        guard foregroundNames.count == 1,
              let foregroundName = foregroundNames.first else {
            fatalError("Failed to find foregroundName for specified pair '\(name)'.")
        }

        guard backgroundNames.count == 1,
              let backgroundName = backgroundNames.first else {
            fatalError("Failed to find backgroundName for specified pair '\(name)'.")
        }

        return (foregroundName:foregroundName, backgroundName:backgroundName)
    }

}
