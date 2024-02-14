class PortalBehavior: Behavior {
    var destination: Tile

    init(destination: Tile) {
        self.destination = destination
    }

    var description: String {
        "Portal"
    }

    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?) {
        if case .slideOn = context {
            levelMovableObject.tile = destination
        }
    }
}
