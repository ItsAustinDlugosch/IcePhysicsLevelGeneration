class Tile: LevelObject {    
    var status: TileStatus
    var behavior: TileBehavior = TileBehavior()

    init(level: Level, position: LevelPoint,
         status: TileStatus = .nonPaintable, behavior: TileBehavior? = nil) {
        self.status = status
        if let behavior = behavior {            
            self.behavior = behavior
        }
        super.init(level: level, position: position)
    }
        
    // Adjacency Stitched by FaceLevel and Level
    weak var up: Tile!
    weak var down: Tile!
    weak var left: Tile!
    weak var right: Tile!

    // Stores LevelObject located on tile
    weak var entity: Entity?

   override var description: String {
       "\(behavior.description), \(status)"
    }

   override func activate(in level: Level, levelObject: LevelObject, context: ActivationContext) {
       if let entity = levelObject as? Entity {
           activate(in: level, entity: entity, context: context)
       }
   }
   func activate(in level: Level, entity: Entity, context: ActivationContext) {
       behavior.activate(in: level, entity: entity, context: context)
       self.entity?.activate(in: level, tile: self, context: context)       
   }
}
