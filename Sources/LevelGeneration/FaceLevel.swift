import Foundation

public struct FaceLevel { // Represents one side of a level within our game
    public let faceSize: FaceSize
    public let face: Face    

    public var tiles: [[Tile]]
    public init(faceSize: FaceSize, face: Face) {
        self.faceSize = faceSize
        self.face = face

        // Create the grid tiles and set their state as inactive by default
        var tiles = [[Tile]]()
        for x in 0 ..< faceSize.maxX {
            var tileColumn = [Tile]()
            for y in 0 ..< faceSize.maxY {
                tileColumn.append(Tile(point: LevelPoint(face: face, x: x, y: y), tileStatus: .nonPaintable))
            }
            tiles.append(tileColumn)
        }
        self.tiles = tiles
        setSpecialTileType(levelPoints: borderPoints(), specialTileType: .wall)
    }

    public init?(intTiles: [[Int]], specialTileData: [LevelPoint: any SpecialTileTypeData], face: Face) {
        func tilesToFaceSize<T>(_ grid: [[T]]) -> FaceSize? {
            let maxY = grid.count
            guard maxY != 0, let firstRow = grid.first else {
                return nil
            }
            if grid.allSatisfy({ $0.count == firstRow.count }) {
                return FaceSize(maxX: firstRow.count, maxY: maxY)
            }
            return nil
        }

        guard let faceSize = tilesToFaceSize(intTiles) else {
            return nil
        }
        self.faceSize = faceSize
        self.face = face
        var tiles = [[Tile]]()
        for x in 0 ..< intTiles.count {
            var tileColumn = [Tile]()
            for y in 0 ..< intTiles[x].count  {
                let specialTileType: SpecialTileType?
                switch intTiles[x][y] {
                case 0:
                    specialTileType = nil
                case 1:
                    specialTileType = .wall
                case 2:
                    guard let pair = specialTileData[LevelPoint(face: face, x: x, y: y)] as? DirectionPair else {
                        fatalError("Expected associated value of DirectionPair at LevelPoint(face: \(face.rawValue), x: \(x), y: \(y)).")
                    }
                    specialTileType = .directionShift(pair: pair)
                case 3:
                    guard let destination = specialTileData[LevelPoint(face: face, x: x, y: y)] as? LevelPoint else {
                        fatalError("Expected associated value of LevelPoint at LevelPoint(face: \(face.rawValue), x: \(x), y: \(y)).")
                    }
                    specialTileType = .portal(to: destination)
                case 4:
                    specialTileType = .sticky
                default:
                    print("Unexpected tile state: \(intTiles[x][y])")
                    return nil
                }
                tileColumn.append(Tile(point: LevelPoint(face: face, x: x, y: y), specialTileType: specialTileType))
            }
            tiles.append(tileColumn)
        }        
        self.tiles = tiles
    }

    // Initializing function that is used to set the status of one or multiple tiles
    public mutating func setTileStatus(levelPoint: LevelPoint, tileStatus: TileStatus) {
        tiles[levelPoint.x][levelPoint.y].tileStatus = tileStatus
    }
    public mutating func setTileStatus<T: Collection>(levelPoints: T, tileStatus: TileStatus) where T.Element == LevelPoint {
        levelPoints.forEach { setTileStatus(levelPoint: $0, tileStatus: tileStatus) }
    }
    
    // Initializing function that is used to change the status of one or multiple tiles if they match a current tile status
    public mutating func changeTileStatusIfCurrent(levelPoint: LevelPoint, current currentTileStatus: TileStatus, new newTileStatus: TileStatus) {
        if tiles[levelPoint.x][levelPoint.y].tileStatus == currentTileStatus {
            tiles[levelPoint.x][levelPoint.y].tileStatus = newTileStatus
        }
    }
    public mutating func changeTileStatusIfCurrent<T: Collection>(levelPoints: T, current currentTileStatus: TileStatus, new newTileStatus: TileStatus) where T.Element == LevelPoint {
        levelPoints.forEach { changeTileStatusIfCurrent(levelPoint: $0, current: currentTileStatus, new: newTileStatus) }
    }

    // Initializing function that is used to set the sepcialTileType of one or multiple tiles
    public mutating func setSpecialTileType(levelPoint: LevelPoint, specialTileType: SpecialTileType?) {
        tiles[levelPoint.x][levelPoint.y].specialTileType = specialTileType
    }
    public mutating func setSpecialTileType<T: Collection>(levelPoints: T, specialTileType: SpecialTileType?) where T.Element == LevelPoint {
        levelPoints.forEach { setSpecialTileType(levelPoint: $0, specialTileType: specialTileType) }
    }
    
    // Returns the points of all tiles with a tile status and type
    public func tilePointsOfStatus(tileStatus: TileStatus) -> Set<LevelPoint> {
        var tilePointsOfStatus = Set<LevelPoint>()
        for tileColumn in tiles {
            for tile in tileColumn {
                if tiles[tile.point.x][tile.point.y].tileStatus == tileStatus {
                    tilePointsOfStatus.insert(tile.point)
                }
            }
        }
        return tilePointsOfStatus
    }
    public func tilePointsOfType(specialTileType: SpecialTileType?) -> Set<LevelPoint> {
        var tilePointsOfType = Set<LevelPoint>()
        for tileColumn in tiles {
            for tile in tileColumn {
                if tiles[tile.point.x][tile.point.y].specialTileType == specialTileType {
                    tilePointsOfType.insert(tile.point)
                }
            }
        }
        return tilePointsOfType
    }
    public func tilePointsOfStatusAndType(tileStatus: TileStatus, specialTileType: SpecialTileType?) -> Set<LevelPoint> {
        return tilePointsOfStatus(tileStatus: tileStatus).intersection(tilePointsOfType(specialTileType: specialTileType))
    }


    // Returns the points of tiles along the border of a face
    public func borderPoints() -> [LevelPoint] {
        return [LevelPoint](Direction.allCases.map { borderPointsByDirection($0) }.joined())
    }

    public func borderPointsByDirection(_ direction: Direction) -> [LevelPoint] {
        guard faceSize.maxX > 0 && faceSize.maxY > 0 else {
            fatalError("Cannot access borderPoints from empty FaceLevel.")
        }
        switch direction {
        case .up:
            return tiles.map { $0.first!.point }
        case .down:
            return tiles.map { $0.last!.point }
        case .left:
            return tiles.first!.map { $0.point }
        case .right:
            return tiles.last!.map { $0.point }
        }
    }

    // Prints the grid
    public func printFaceLevel() {
        for y in 0 ..< faceSize.maxY {
            var descriptionRow = [String]()
            for x in 0 ..< faceSize.maxX {
                if let specialTileType = tiles[x][y].specialTileType {
                    descriptionRow.append(specialTileType.description)
                } else {
                    descriptionRow.append(tiles[x][y].tileStatus.description)
                }
            }
            print(descriptionRow)
        }
    }
}
extension FaceLevel: Equatable, Hashable {
    public static func ==(lhs: FaceLevel, rhs: FaceLevel) -> Bool {
        return lhs.face == rhs.face &&
          lhs.faceSize == rhs.faceSize &&
          lhs.tiles == rhs.tiles
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(face)
        hasher.combine(faceSize)
        hasher.combine(tiles)
    }
}
