public enum SpecialTileType: CustomStringConvertible, Hashable, Equatable {    
    case wall // Represents a tile that the player will collide and end a slide with
    case directionShift(pair: DirectionPair) // Represents a tile that the player will shift directions on, acts as a wall for other two directions
    case portal(to: LevelPoint) // Represents a tile with a link to another
    
    
    public var description: String {
        switch self {
        case .wall:
            return "wall"
        case .directionShift:
            return "directionShift"
        case .portal:
            return "portal"
        }
    }

    public static func ==(lhs: SpecialTileType, rhs: SpecialTileType) -> Bool {
        switch (lhs, rhs) {
        case (.wall, .wall):
            return true
        case (.directionShift(let leftPair), .directionShift(let rightPair)):
            return leftPair == rightPair
        case (.portal(let leftDestination), .portal(let rightDestination)):
            return leftDestination == rightDestination
        default:
            return false
        }        
    }
}

public protocol SpecialTileTypeData {
}
