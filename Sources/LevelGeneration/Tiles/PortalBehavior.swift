class PortalBehavior: TileBehavior {
    var destination: Tile

    init(destination: Tile) {
        self.destination = destination
    }

    override var description: String {
        "Portal" + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            entity.tile = destination
        }
    }
}
