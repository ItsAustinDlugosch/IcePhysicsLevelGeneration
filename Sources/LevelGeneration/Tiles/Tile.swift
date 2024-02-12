class Tile: TileBehavior, CustomStringConvertible {    
    var point: LevelPoint
    var status: TileStatus = .nonPaintable
    
    init(point: LevelPoint) {
        self.point = point
    }

    // Adjacency Stitched by FaceLevel and Level
    weak var up: Tile!
    weak var down: Tile!
    weak var left: Tile!
    weak var right: Tile!

    // Stores LevelObject located on tile
    weak var levelObject: LevelObject?

    var description: String {
        "Tile, \(status)"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level,
                  context: ActivationContext, direction: Direction) {
        if case .startOn = context, levelMovableObject is Player {
            status = .critical
        }
        if case .slideOn = context, levelMovableObject is Player {
            status = .paintable
        }
        if case .stopOn = context, levelMovableObject is Player {
            status = .critical
        }
    }
}

protocol TileBehavior: CustomStringConvertible {
    func activate(by levelMovableObject: LevelMovableObject, in level: Level,
                  context: ActivationContext, direction: Direction)
}
