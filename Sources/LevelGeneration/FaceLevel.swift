class FaceLevel {
    let face: Face
    let faceSize: FaceSize
    
    var tiles: [[Tile]]

    init(face: Face, faceSize: FaceSize) {
        self.face = face
        self.faceSize = faceSize
        self.tiles = Array(repeating: Array(repeating: Tile(point: LevelPoint(face: face, x: 0, y: 0)), count: faceSize.maxY), count: faceSize.maxX)
        
        // Initialize tiles as basic nonPaintable tiles
        for x in 0..<faceSize.maxX {
            for y in 0..<faceSize.maxY {
                self.tiles[x][y] = Tile(point: LevelPoint(face: face, x: x, y: y))
            }
        }
        makeBordersWallTiles()
        setupFaceTileAdjacency()
    }

    // Initializing Functions   
    private func setupFaceTileAdjacency() { // Only sets up adjacency for tiles within the Face, edges are handled within the Level
        for (x, column) in tiles.enumerated() {
            for (y, tile) in column.enumerated() {
                if y > 0 {
                    tile.up = tiles[x][y - 1]
                }
                if y < column.count - 1 {
                    tile.down = tiles[x][y + 1]
                }
                if x > 0 {
                    tile.left = tiles[x - 1][y]
                }
                if x < tiles.count - 1 {
                    tile.right = tiles[x + 1][y]
                }
            }
        }
    }
    
    var topBorderTiles: [Tile] {
        return tiles.map {
            precondition($0.count > 0)
            return $0.first!
        }
    }
    var bottomBorderTiles: [Tile] {
        return tiles.map {
            precondition($0.count > 0)
            return $0.last!
        }
    }
    var leftBorderTiles: [Tile] {
        precondition(tiles.count > 0)
        return tiles.first!
    }
    var rightBorderTiles: [Tile] {
        precondition(tiles.count > 0)
        return tiles.last!
    }
    
    private func makeBordersWallTiles() {
        for tile in topBorderTiles + bottomBorderTiles + leftBorderTiles + rightBorderTiles {
            self.tiles[tile.point.x][tile.point.y] = SpecialTile(point: tile.point, behavior: WallBehavior())
        }
    }

    func printFaceLevel() {     
        for y in 0 ..< faceSize.maxY {
            var descriptionRow = [String]()
            for x in 0 ..< faceSize.maxX {
                descriptionRow.append(tiles[x][y].description)
            }
            print(descriptionRow)
        }            
    }
}
