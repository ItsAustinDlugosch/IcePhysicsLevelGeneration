class StickyBehavior: TileBehavior {

    override var description: String {
        "Sticky" + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            entity.slideDirection = nil
        }
    }
    
}
