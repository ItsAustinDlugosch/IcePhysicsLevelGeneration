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
                tileColumn.append(Tile(point: LevelPoint(face: face, x: x, y: y), tileState: .inactive))
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

    // Initializing function that is used to set the state of one or multiple tiles
    public mutating func setTileState(levelPoint: LevelPoint, tileState: TileState) {
        tiles[levelPoint.x][levelPoint.y].tileState = tileState
    }
    public mutating func setTileState(levelPoints: [LevelPoint], tileState: TileState) {
        levelPoints.forEach { setTileState(levelPoint: $0, tileState: tileState) }
    }
    
    // Initializing function that is used to change the state of one or multiple tiles if they match a current tile state
    public mutating func changeTileStateIfCurrent(levelPoint: LevelPoint, current currentTileState: TileState, new newTileState: TileState) {
        if tiles[levelPoint.x][levelPoint.y].tileState == currentTileState {
            tiles[levelPoint.x][levelPoint.y].tileState = newTileState
        }
    }
    public mutating func changeTileStateIfCurrent(levelPoints: [LevelPoint], current currentTileState: TileState, new newTileState: TileState) {
        levelPoints.forEach { changeTileStateIfCurrent(levelPoint: $0, current: currentTileState, new: newTileState) }
    }

    // Initializing function that is used to set the sepcialTileType of one or multiple tiles
    public mutating func setSpecialTileType(levelPoint: LevelPoint, specialTileType: SpecialTileType?) {
        tiles[levelPoint.x][levelPoint.y].specialTileType = specialTileType
    }
    public mutating func setSpecialTileType(levelPoints: [LevelPoint], specialTileType: SpecialTileType?) {
        levelPoints.forEach { setSpecialTileType(levelPoint: $0, specialTileType: specialTileType) }
    }

    // Returns the points of tiles along the border of a face
    public func borderPoints() -> [LevelPoint] {
        var borderPoints = [LevelPoint]()
        for tileColumn in tiles {
            for tile in tileColumn {
                if tile.point.x == 0 || tile.point.x == (faceSize.maxX - 1) ||
                     tile.point.y == 0 || tile.point.y == (faceSize.maxY - 1) {
                    borderPoints.append(tile.point)
                }
            }
        }
        return borderPoints
    }
    
    // Returns the points of all tiles with a tile state
    public func tilePointsOfStateAndType(tileState: TileState, specialTileType: SpecialTileType? = nil) -> [LevelPoint] {
        var tilePointsOfState = [LevelPoint]()
        for tileColumn in tiles {
            for tile in tileColumn {
                if tiles[tile.point.x][tile.point.y].tileState == tileState &&
                     tiles[tile.point.x][tile.point.y].specialTileType == specialTileType {
                    tilePointsOfState.append(tile.point)
                }
            }
        }
        return tilePointsOfState
    }

    // Prints the grid
    public func printFaceLevel() {
        for y in 0 ..< faceSize.maxY {
            var descriptionRow = [String]()
            for x in 0 ..< faceSize.maxX {
                if let specialTileType = tiles[x][y].specialTileType {
                    descriptionRow.append(specialTileType.description)
                } else {
                    descriptionRow.append(tiles[x][y].tileState.description)
                }
            }
            print(descriptionRow)
        }
    }
}    
