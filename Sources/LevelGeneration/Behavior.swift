protocol Behavior: CustomStringConvertible {
    func activate(in level: Level, levelObject: LevelObject, context: ActivationContext)
}
// Default Tile Behavior
class TileBehavior: Behavior {
    var description: String {
        "Tile"
    }
    
    func activate(in level: Level, entity: Entity, context: ActivationContext) {
        activate(in: level, levelObject: entity, context: context)
    }
    func activate(in level: Level, levelObject: LevelObject, context: ActivationContext) {
    }
}
// Default Entity Behavior
class EntityBehavior: Behavior {
    var description: String {
        "Entity"
    }
    
    func activate(in level: Level, tile: Tile, context: ActivationContext) {
        activate(in: level, levelObject: tile, context: context)
    }
    func activate(in level: Level, levelObject: LevelObject, context: ActivationContext) {
    }
}
