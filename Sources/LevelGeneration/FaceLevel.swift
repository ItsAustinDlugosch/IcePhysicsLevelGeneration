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
        setBordersToWall() // Testing purposes
    }

    public init?(intTiles: [[Int]], face: Face) {
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
                let tileState: TileState
                switch intTiles[x][y] {
                case 0:
                    tileState = .inactive
                case 1:
                    tileState = .wall
                default:
                    print("Unexpected tile state: \(intTiles[x][y])")
                    return nil
                }
                tileColumn.append(Tile(point: LevelPoint(face: face, x: x, y: y), tileState: tileState))
            }
            tiles.append(tileColumn)
        }        
        self.tiles = tiles
    }

    // Initializing function that sets the state of border tiles to .wall
    mutating func setBordersToWall() {
        let borderPoints = borderPoints()
        for borderPoint in borderPoints {
            tiles[borderPoint.x][borderPoint.y].tileState = .wall
        }
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
    public func tilePointsOfState(tileState: TileState) -> [LevelPoint] {
        var tilePointsOfState = [LevelPoint]()
        for tileColumn in tiles {
            for tile in tileColumn {
                if tiles[tile.point.x][tile.point.y].tileState == tileState {
                    tilePointsOfState.append(tile.point)
                }
            }
        }
        return tilePointsOfState
    }

    // Prints the grid
    public func printTileStates() {
        for y in 0 ..< faceSize.maxY {
            var stateRow = [TileState]()
            for x in 0 ..< faceSize.maxX {
                stateRow.append(tiles[x][y].tileState)
            }
            print(stateRow)
        }
    }
}    
