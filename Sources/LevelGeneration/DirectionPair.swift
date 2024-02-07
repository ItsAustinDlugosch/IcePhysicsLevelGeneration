public struct DirectionPair: SpecialTileTypeData, Equatable, Hashable, Codable {

    let entranceOne: Direction
    let entranceTwo: Direction

    public init(_ entranceOne: Direction, _ entranceTwo: Direction) {
        self.entranceOne = entranceOne
        self.entranceTwo = entranceTwo
    }
    
    func shiftDirection(_ entrance: Direction) -> Direction? {
        if entrance == entranceOne {
            return entranceTwo.toggle()
        }
        if entrance == entranceTwo {
            return entranceOne.toggle()
        }
        return nil
    }
    
    public static func ==(lhs: DirectionPair, rhs: DirectionPair) -> Bool {
        return Set([lhs.entranceOne, lhs.entranceTwo]) == Set([rhs.entranceOne, rhs.entranceTwo])
    }

    private enum CodingKeys: String, CodingKey {
        case entranceOne = "entrance_one"
        case entranceTwo = "entrance_two"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entranceOne, forKey: .entranceOne)
        try container.encode(entranceTwo, forKey: .entranceTwo)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let entranceOne = try container.decode(Direction.self, forKey: .entranceOne)
        let entranceTwo = try container.decode(Direction.self, forKey: .entranceTwo)
        self = DirectionPair(entranceOne, entranceTwo)
    }
      
}
