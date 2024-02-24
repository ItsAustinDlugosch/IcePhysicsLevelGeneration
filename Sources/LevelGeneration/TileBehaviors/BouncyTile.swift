class BouncyTile: Behavior {

    var description: String {
        "Bouncy"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideInto = context {
            entity.slideDirection = entity.slideDirection?.toggle()
        }
    }
    
}
