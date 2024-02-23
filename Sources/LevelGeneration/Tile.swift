class Tile: LevelObject {    
    var status: TileStatus
    var behavior: Behavior?

    init(level: Level, position: LevelPoint,
         status: TileStatus = .nonPaintable, behavior: Behavior? = nil) {
        self.status = status
        self.behavior = behavior
        super.init(level: level, position: position)
    }
        
    // Adjacency Stitched by FaceLevel and Level
    weak var up: Tile!
    weak var down: Tile!
    weak var left: Tile!
    weak var right: Tile!

    weak var entity: Entity? {
        willSet {
            print("changing tile entity from \(entity?.description ?? "nothing")")
        }
        didSet {
            print("changed tile entity to \(entity?.description ?? "nothing")")
        }
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
       "\(entity?.description ?? behavior?.description ?? "Tile"), \(status)"
    }

   func activate(entity: Entity, context: ActivationContext) {
       if behavior != nil {
           behavior!.activate(entity: entity, context: context)
       }
       if let tileEntity = self.entity {           
           if let player = tileEntity as? Player {
               player.updateTileStatus(context: context)
           }
           if entity !== tileEntity {
               print("portal tele, \(context)")
               tileEntity.behavior?.activate(entity: entity, context: context)
               print(entity.tile.position)
               print((tileEntity.behavior! as! PortalBehavior).destination.position)
           }
       }
   }
}
