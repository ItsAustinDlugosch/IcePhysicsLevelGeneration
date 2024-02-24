class PortalBehavior: Behavior {
    
    var destination: Tile

    init(destination: Tile) {
        self.destination = destination
    }

    var description: String {
        "Portal"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideInto = context {
            entity.currentTile = destination
        }
    }
}
