class MagnetBehavior: Behavior {

    var description: String {
        "Magnet"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideAdjacent = context {
            entity.slideDirection = nil
        }
    }
    
}
