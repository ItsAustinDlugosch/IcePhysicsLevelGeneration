class PortalBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideOn]
    
    var destination: Tile

    init(destination: Tile) {
        self.destination = destination
    }

    var description: String {
        "Portal"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            print("teleporting \(entity.description)")
            entity.tile = destination
        }
    }
}
