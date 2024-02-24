class StickyBehavior: Behavior {

    var description: String {
        "Sticky"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            entity.slideDirection = nil
        }
    }
    
}
