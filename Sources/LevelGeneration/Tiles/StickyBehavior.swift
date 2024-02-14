class StickyBehavior: Behavior {

    // Empty Initializer, Sticky Behavior requires no specific input or associated value
    init() {}

    var description: String {
        "Sticky"
    }

    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?) {        
    }
    
}
