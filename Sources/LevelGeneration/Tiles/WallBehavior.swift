class WallBehavior: TileBehavior {

    // Empty Initializer, Wall Behavior requires no specific input or associated value
    init() {}

    var description: String {
        "Wall"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        if case .slideInto = context {
            // Stop Player by setting slideDirection to nil            
            levelMovableObject.slideDirection = nil
        }
    }
}
