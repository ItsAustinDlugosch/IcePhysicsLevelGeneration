import Foundation

class Entity: LevelObject, DynamicFeature {

    let id: UUID
    var currentTile: Tile {
        didSet {
            updateTileStatus()
        }
    }
    var slideDirection: Direction? = nil {
        willSet(newDirection) {
            if slideDirection == nil && newDirection != nil {
                updateTileStatus()
            }
        }
        didSet {
            if oldValue != nil && slideDirection == nil {
                updateTileStatus()
            }
        }
    }

    override init(level: Level, position: LevelPoint, behavior: Behavior? = nil) {
        guard let startingTile = level.tiles[position] else {
            fatalError("LevelPoint out of range")
        }
        self.id = UUID()
        self.currentTile = startingTile        
        super.init(level: level, position: position, behavior: behavior)
    }

    override var description: String {
        "Entity"
    }

    func isSliding() -> Bool {
        return slideDirection == nil ? false : true        
    }

    func nextTile() -> Tile? {
        switch slideDirection {
        case .up: return currentTile.up
        case .down: return currentTile.down
        case .left: return currentTile.left
        case .right: return currentTile.right
        case nil: return nil
        }
    }

    func updateTileStatus() {
    }

    func updateState(in level: Level) {       
    }
}

extension Entity: Equatable, Hashable {

    static func ==(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id == rhs.id        
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
