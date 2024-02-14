class Tile: LevelObject {    
    var status: TileStatus = .nonPaintable
        
    // Adjacency Stitched by FaceLevel and Level
    weak var up: Tile!
    weak var down: Tile!
    weak var left: Tile!
    weak var right: Tile!

    // Stores LevelObject located on tile
    weak var levelMovableObject: LevelMovableObject?

   override var description: String {
        "Tile, \(status)"
    }

    override func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                           context: ActivationContext, slideDirection: Direction?) {
        if levelMovableObject is Player {
            switch context {
            case .startOn, .stopOn:
                status = .critical
            case .slideOn:
                status = .paintable
            default:
                return
            }
        }
    }
}
