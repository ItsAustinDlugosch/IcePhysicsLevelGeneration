class DynamicTile: Tile, DynamicFeature {

    var dynamicTileBehavior: TileBehavior? {
        didSet {
            // What when behavior become dynamic
            print("Dynamic tile behavior change")
        }
    }

    override init(level: Level, position: LevelPoint,
                  status: TileStatus = .nonPaintable, behavior: TileBehavior? = nil) {
        // Dynamic Tile Behavior can be changed by other tiles, it is initialized with its initial behavior and dynamicBehaviorChanges are defined within other TileBehaviors that affect other tiles (ex: ButtonBehavior)
        super.init(level: level, position: position, behavior: behavior)
        self.dynamicTileBehavior = behavior
    }

    override var description: String {
        (dynamicTileBehavior?.description ?? "Dynamic") + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        dynamicTileBehavior?.activate(in: level, entity: entity, context: context) ?? super.activate(in: level, entity: entity, context: context)
    }
    
    func updateState(in level: Level) {        
    }
    
}
