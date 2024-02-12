class SpecialTile: Tile {
    var behavior: TileBehavior?

    init(point: LevelPoint, behavior: TileBehavior? = nil) {
        self.behavior = behavior
        super.init(point: point)
    }

    override var description: String {
        (behavior?.description ?? "Special") + super.description
    }

    override func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        behavior?.activate(by: levelMovableObject, in: level, context: context, direction: direction)
        super.activate(by: levelMovableObject, in: level, context: context, direction: direction)
    }
}
