class BouncyTile: Behavior {
    static let activatedBy: [ActivationContext] = [.slideInto]

    var description: String {
        "Bouncy"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideInto = context {
            entity.slideDirection = entity.slideDirection?.toggle()
        }
    }
    
}
