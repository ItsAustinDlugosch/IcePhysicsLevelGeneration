public struct Tile { // Represents a tile on the level grid
    public let point: LevelPoint // Each tile has a point
    public var tileState: TileState // The state of each tile
    public var specialTileType: SpecialTileType? // The type of tile, nil is a basic tile

    public init(point: LevelPoint, tileState: TileState = .inactive, specialTileType: SpecialTileType? = nil) {        
        self.point = point
        self.tileState = tileState
        self.specialTileType = specialTileType
    }
}

extension Tile: Equatable, Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
        hasher.combine(tileState)
        hasher.combine(specialTileType)
    }
    
    public static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.point == rhs.point &&
          lhs.tileState == rhs.tileState &&
          lhs.specialTileType == rhs.specialTileType
    }
}
