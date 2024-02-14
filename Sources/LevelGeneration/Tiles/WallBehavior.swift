class WallBehavior: TileBehavior {

    override var description: String {
        "Wall" + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        if case .slideInto = context {            
            // Stop Player by setting slideDirection to nil            
            entity.slideDirection = nil
        }
    }
}
