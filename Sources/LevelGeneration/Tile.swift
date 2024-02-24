class Tile: LevelObject {    
    var status: TileStatus = .nonPaintable
        
    // Adjacency Stitched by FaceLevel and Level
    weak var up: Tile!
    weak var down: Tile!
    weak var left: Tile!
    weak var right: Tile!

    var upPoint: LevelPoint {
        return up.position
    }
    var downPoint: LevelPoint {
        return down.position
    }
    var leftPoint: LevelPoint {
        return left.position
    }
    var rightPoint: LevelPoint {
        return right.position
    }

    func adjacentTileDirection(_ tile: Tile) -> Direction? {
        if self.up === tile {
            return .up
        }
        if self.down === tile {
            return .down
        }
        if self.left === tile {
            return .left
        }
        if self.right === tile {
            return .right
        }
        return nil
    }

   override var description: String {
       "\(behavior?.description ?? "") Tile, \(status)"
    }
}
