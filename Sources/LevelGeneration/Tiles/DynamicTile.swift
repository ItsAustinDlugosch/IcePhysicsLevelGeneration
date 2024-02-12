class DynamicTile: SpecialTile, DynamicFeature {

    var dynamicBehavior: TileBehavior? {
        didSet {
            // What when behavior become dynamic
            print("Dynamic tile behavior change")
        }
    }

    override init(point: LevelPoint, behavior: TileBehavior? = nil) {
        super.init(point: point, behavior: behavior)
        self.dynamicBehavior = behavior
    }

    override var description: String {
        (dynamicBehavior?.description ?? "Dynamic") + super.description
    }

    override func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        dynamicBehavior?.activate(by: levelMovableObject, in: level, context: context, direction: direction) ?? super.activate(by: levelMovableObject, in: level, context: context, direction: direction)
    }
    
    func updateState(in level: Level) {        
    }
    
}
