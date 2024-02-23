struct Collision {
    let type: CollisionType
    let context: CollisionContext

    init(type: CollisionType, context: CollisionContext) {
        self.type = type
        self.context = context
    }
}
// Denotes whether the collision occurs on a tile edge or on a specific tile
enum CollisionType {
    case intersectTileEdge
    case intersectTile
}
// Denotes whether the collision was head on or adjacent
enum CollisionContext {
    case headOn
    case adjacent
}
