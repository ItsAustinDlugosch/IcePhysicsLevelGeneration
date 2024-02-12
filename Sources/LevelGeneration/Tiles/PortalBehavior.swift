class PortalBehavior: TileBehavior {
    var destination: Tile

    init(destination: Tile) {
        self.destination = destination
    }

    var description: String {
        "Portal"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        if case .slideOn = context {
            levelMovableObject.tile = destination
        }
    }
}
