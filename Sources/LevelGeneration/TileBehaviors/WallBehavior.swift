class WallBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideInto]

    var description: String {
        "Wall" 
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideInto = context {            
            // Stop Player by setting slideDirection to nil            
            entity.slideDirection = nil
        }
    }
}
