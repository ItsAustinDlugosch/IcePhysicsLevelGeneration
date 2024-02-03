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
            return entranceTwo.toggle()
        }
        return nil
    }
    
    public static func ==(lhs: DirectionPair, rhs: DirectionPair) -> Bool {
        return Set([lhs.entranceOne, lhs.entranceTwo]) == Set([rhs.entranceOne, rhs.entranceTwo])
    }
}
