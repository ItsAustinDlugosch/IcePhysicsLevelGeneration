class DynamicTile: SpecialTile, DynamicFeature {

    var dynamicBehavior: Behavior? {
        didSet {
            // What when behavior become dynamic
            print("Dynamic tile behavior change")
        }
    }

    override init(level: Level, position: LevelPoint, behavior: Behavior? = nil) {
        super.init(level: level, position: position, behavior: behavior)
        self.dynamicBehavior = behavior
    }

    override var description: String {
        (dynamicBehavior?.description ?? "Dynamic") + super.description
    }

    override func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                           context: ActivationContext, slideDirection: Direction?) {
        dynamicBehavior?.activate(in: level, by: levelMovableObject, context: context, slideDirection: slideDirection) ?? super.activate(in: level, by: levelMovableObject, context: context, slideDirection: slideDirection)
    }
    
    func updateState(in level: Level) {        
    }
    
}
