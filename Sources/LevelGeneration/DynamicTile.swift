class DynamicTile: Tile, DynamicFeature {

    var dynamicTileBehavior: Behavior? {
        didSet {
            // What when behavior become dynamic
            print("Dynamic tile behavior change")
        }
    }

    override init(level: Level, position: LevelPoint,
                  status: TileStatus = .nonPaintable, behavior: Behavior? = nil) {
        // Dynamic Tile Behavior can be changed by other tiles, it is initialized with its initial behavior and dynamicBehaviorChanges are defined within other TileBehaviors that affect other tiles (ex: ButtonBehavior)
        super.init(level: level, position: position, behavior: behavior)
        self.dynamicTileBehavior = behavior
    }

    override var description: String {
        (dynamicTileBehavior?.description ?? "Dynamic") + super.description
    }

    override func activate(entity: Entity, context: ActivationContext) {
        dynamicTileBehavior?.activate(entity: entity, context: context) ?? super.activate(entity: entity, context: context)
    }
    
    func updateState(in level: Level) {        
    }
    
}
