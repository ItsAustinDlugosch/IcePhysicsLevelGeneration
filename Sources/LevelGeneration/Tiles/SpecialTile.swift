class SpecialTile: Tile {
    var behavior: Behavior?

    init(level: Level, position: LevelPoint, behavior: Behavior? = nil) {
        self.behavior = behavior
        super.init(level: level, position: position)
    }

    override var description: String {
        (behavior?.description ?? "Special") + super.description
    }

    override func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                           context: ActivationContext, slideDirection: Direction?) {
        behavior?.activate(in: level, by: levelMovableObject, context: context, slideDirection: slideDirection)
        super.activate(in: level, by: levelMovableObject, context: context, slideDirection: slideDirection)
    }
}
