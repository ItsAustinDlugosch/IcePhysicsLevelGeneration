class Player: Entity {

    // No option for behavior
    init(level: Level, position: LevelPoint) {
        super.init(level: level, position: position)
    }

    override var description: String {
        "Player" + super.description
    }

    override func updateTileStatus() {
        if slideDirection != nil {
            currentTile.status = .paintable
        } else {
            currentTile.status = .critical
        }
    }
}
