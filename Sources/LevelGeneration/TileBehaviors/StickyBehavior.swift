class StickyBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideOn]

    var description: String {
        "Sticky"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            entity.slideDirection = nil
        }
    }
    
}
