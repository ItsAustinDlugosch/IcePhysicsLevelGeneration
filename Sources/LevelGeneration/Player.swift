class Player: Entity {

    // No option for behavior
    init(level: Level, startingPosition: LevelPoint) {
        super.init(level: level, startingPosition: startingPosition)
    }

    override var description: String {
        "Player" + super.description
    }

    func updateTileStatus(context: ActivationContext) {
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
