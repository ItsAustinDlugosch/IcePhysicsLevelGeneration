class Player: Entity {

    override func activate(in level: Level, tile: Tile, context: ActivationContext) {
        switch context {
        case .startOn, .stopOn:
            tile.status = .critical
        case .slideOn where tile.status != .critical:
            tile.status = .paintable
        default:
            return
        }
    }
}
