class StickyBehavior: TileBehavior {

    // Empty Initializer, Sticky Behavior requires no specific input or associated value
    init() {}

    var description: String {
        "Sticky"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {        
    }
    
}
