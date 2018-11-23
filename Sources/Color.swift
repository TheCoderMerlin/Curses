public class Color {
    private let colors = Colors.shared

    public let name : String
    public let red : Int     // Value in thousandths
    public let green : Int   // Value in thousandths
    public let blue : Int    // Value in thousandths

    // Creates a new, named color
    public init(name:String, red:Int, green:Int, blue:Int) {
        colors.startIfNecessary()
        
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue

        colors.add(name:name, red:red, green:green, blue:blue)
    }

    // Retrieves a previously defined, named color
    public init(name:String) {
        colors.startIfNecessary()
        
        let (red, green, blue) = colors.color(name:name)
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue

    }
}
