class Entity: LevelObject, DynamicFeature {
    // Objects that conform can move within the level, returns whether the move was successful
    var tile: Tile {
        didSet {
            tile.entity = self
        }
    }

    var behavior: EntityBehavior = EntityBehavior()
    var slideDirection: Direction? = nil

    init(level: Level, startingPosition: LevelPoint, behavior: EntityBehavior? = nil) {
        guard let startingTile = level.tiles[startingPosition] else {
            fatalError("Starting position is no contained by level.")
        }
        self.tile = startingTile
        if let behavior = behavior {
            self.behavior = behavior
        }
        super.init(level: level, position: startingPosition)
    }

    
    func slide(_ direction: Direction) {

        func getNextTile(direction: Direction) -> Tile {
            var nextTile: Tile
            switch direction {
            case .up:
                nextTile = tile.up
            case .down:
                nextTile = tile.down
            case .left:
                nextTile = tile.left
            case .right:
                nextTile = tile.right
            }
            return nextTile
        }
        
        slideDirection = direction
        // Start Activation Context       
        tile.activate(in: level, levelObject: self, context: .startOn)
        tile.up.activate(in: level, levelObject: self, context: .startAdjacent(.down))
        tile.down.activate(in: level, levelObject: self, context: .startAdjacent(.up))
        tile.left.activate(in: level, levelObject: self, context: .startAdjacent(.right))
        tile.right.activate(in: level, levelObject: self, context: .startAdjacent(.left))

        // Slide Into Activation Context
        var nextTile = getNextTile(direction: direction)
        nextTile.activate(in: level, levelObject: self, context: .slideInto)
        // Loop
        while let direction = slideDirection {
            // Slide Activation Context
            tile = nextTile
            tile.activate(in: level, levelObject: self, context: .slideOn)
            tile.up.activate(in: level, levelObject: self, context: .slideAdjacent(.down))
            tile.down.activate(in: level, levelObject: self, context: .slideAdjacent(.up))
            tile.left.activate(in: level, levelObject: self, context: .slideAdjacent(.right))
            tile.right.activate(in: level, levelObject: self, context: .slideAdjacent(.left))
            // Slide Into Activation Context
            nextTile = getNextTile(direction: direction)
            nextTile.activate(in: level, levelObject: self, context: .slideInto)
        }

        // Stop Activation Context       
        tile.activate(in: level, levelObject: self, context: .stopOn)
        tile.up.activate(in: level, levelObject: self, context: .stopAdjacent(.down))
        tile.down.activate(in: level, levelObject: self, context: .stopAdjacent(.up))
        tile.left.activate(in: level, levelObject: self, context: .stopAdjacent(.right))
        tile.right.activate(in: level, levelObject: self, context: .stopAdjacent(.left))
    }

    // LevelObject Activation
    override func activate(in level: Level, levelObject: LevelObject, context: ActivationContext) {
        if let tile = levelObject as? Tile {
            activate(in: level, tile: tile, context: context)
        }
    }

    // Behavior Activation
    func activate(in level: Level, tile: Tile, context: ActivationContext) {
        behavior.activate(in: level, tile: tile, context: context)
    }
    
    func updateState(in level: Level) {
        print("updated player position")
    }
}
