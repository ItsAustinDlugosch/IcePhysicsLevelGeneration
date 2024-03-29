public struct DirectionPair: SpecialTileTypeData, Equatable, Hashable, Codable {

    public let exitOne: Direction
    public let exitTwo: Direction

    public init?(_ exitOne: Direction, _ exitTwo: Direction) {
        guard exitOne.toggle() != exitTwo, exitTwo.toggle() != exitOne else {
            return nil
        }
        self.exitOne = exitOne
        self.exitTwo = exitTwo
    }
    
    func shiftDirection(_ exit: Direction) -> Direction? {
        if exit == exitOne.toggle() {
            return exitTwo
        }
        if exit == exitTwo.toggle() {
            return exitOne
        }
        return nil
    }
    
    public static func ==(lhs: DirectionPair, rhs: DirectionPair) -> Bool {
        return Set([lhs.exitOne, lhs.exitTwo]) == Set([rhs.exitOne, rhs.exitTwo])
    }

    private enum CodingKeys: String, CodingKey {
        case exitOne = "exit_one"
        case exitTwo = "exit_two"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exitOne, forKey: .exitOne)
        try container.encode(exitTwo, forKey: .exitTwo)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let exitOne = try container.decode(Direction.self, forKey: .exitOne)
        let exitTwo = try container.decode(Direction.self, forKey: .exitTwo)
        guard exitOne.toggle() != exitTwo, exitTwo.toggle() != exitOne else {
            fatalError("Cannot decode invalid direction pair")
        }
        self = DirectionPair(exitOne, exitTwo)!
    }
      
}
