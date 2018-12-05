public class Colors {

    public static let shared = Colors()
    private let curses = Curses.shared

    // Explicitly disable clients from creating objects of this class
    private init() {
    }

    private var started : Bool = false
    private var colorCount = 8 // There are eight default colors at start
    private var pairCount = 1  // There is one default pair at start

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

    public func newColor(red:Int, green:Int, blue:Int) -> Color {
        precondition((0...1000).contains(red), "Red must be in range of 0...1000, not \(red)")
        precondition((0...1000).contains(green), "Green must be in range of 0...1000, not \(green)")
        precondition((0...1000).contains(blue), "Blue must be in range of 0...1000, not \(blue)")
        precondition(colorCount < maxColorCount, "Unable to add more colors, already at maximum \(maxColorCount)")
        precondition(customColorsAreSupported, "Terminal does not support adding colors")

        startIfNecessary()
        
        let newColorIndex = colorCount
        colorCount += 1
        curses.setColor(index:newColorIndex, red:red, green:green, blue:blue)
        return Color(index:newColorIndex, red:red, green:green, blue:blue)
    }

    public func newPair(foreground:Color, background:Color) -> ColorPair {
        precondition(pairCount < maxPairCount, "Unable to add more pairs; already at maximum \(maxPairCount)")

        startIfNecessary()

        let newPairIndex = pairCount
        pairCount += 1
        curses.setColorPair(index:newPairIndex, foregroundIndex:foreground.index, backgroundIndex:background.index)
        return ColorPair(index:newPairIndex, foreground:foreground, background:background)
    }
    
    // ============================== Helper Functions ==============================
    func startIfNecessary() {
        if !started {
            // Start using colors
            curses.startColors()
            
            // Remember that we've started
            started = true
        }
    }


}
