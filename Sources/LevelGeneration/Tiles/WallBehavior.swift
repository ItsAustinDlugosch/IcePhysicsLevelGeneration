class WallBehavior: Behavior {

    // Empty Initializer, Wall Behavior requires no specific input or associated value
    init() {}

    var description: String {
        "Wall"
    }

    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?) {
        print("activated wall")
        if case .slideInto = context {            
            // Stop Player by setting slideDirection to nil            
            levelMovableObject.slideDirection = nil
        }
    }
}
