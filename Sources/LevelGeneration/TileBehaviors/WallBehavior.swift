class WallBehavior: Behavior {

    var description: String {
        "Wall" 
    }

    func activate(entity: Entity, context: ActivationContext) {
        print("activated by context \(context) by entity at \(entity.currentTile.position)")
        if case .slideInto = context {            
            // Stop Player by setting slideDirection to nil
            print("stopping entity")
            entity.slideDirection = nil
        }
    }
}
