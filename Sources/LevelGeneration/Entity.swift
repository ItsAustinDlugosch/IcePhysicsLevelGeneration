class Entity: LevelObject, DynamicFeature {
    // Objects that conform can move within the level, returns whether the move was successful
    var tile: Tile {
        willSet {
            tile.entity = nil
            print("changing tile, previous is \(tile.position)")
        }
        didSet {
            tile.entity = self
            print("changed tile, current is \(tile.position)")
        }
    }
    var slideDirection: Direction? = nil
    var behavior: Behavior?

    init(level: Level, startingPosition: LevelPoint, behavior: Behavior? = nil) {
        guard let startingTile = level.tiles[startingPosition] else {
            fatalError("Starting position is no contained by level.")
        }
        self.tile = startingTile
        self.behavior = behavior        
        super.init(level: level, position: startingPosition)
    }

    override var description: String {
        "Entity"
    }

    func nextTile() -> Tile? {
        switch slideDirection {
        case .up:
            return tile.up
        case .down:
            return tile.down
        case .left:
            return tile.left
        case .right:
            return tile.right
        case nil:
            return nil
        }
    }

    func isSliding() -> Bool {
        return slideDirection == nil ? false : true        
    }

    func startSlideActivation() {
        tile.activate(entity: self, context: .startOn)
        tile.up.activate(entity: self, context: .startAdjacent(.down))
        tile.down.activate(entity: self, context: .startAdjacent(.up))
        tile.left.activate(entity: self, context: .startAdjacent(.right))
        tile.right.activate(entity: self, context: .startAdjacent(.left))
    }

    func continueSlideActivation() {
        tile.activate(entity: self, context: .slideOn)
        tile.up.activate(entity: self, context: .slideAdjacent(.down))
        tile.down.activate(entity: self, context: .slideAdjacent(.up))
        tile.left.activate(entity: self, context: .slideAdjacent(.right))
        tile.right.activate(entity: self, context: .slideAdjacent(.left))        
    }

    func slideIntoActivation() {
        if let nextTile = nextTile() {
            nextTile.activate(entity: self, context: .slideInto)
            print("next tile entity is \(nextTile.entity?.description)")
        }
    }

    func stopSlideActivation() {
        tile.activate(entity: self, context: .stopOn)
        tile.up.activate(entity: self, context: .stopAdjacent(.down))
        tile.down.activate(entity: self, context: .stopAdjacent(.up))
        tile.left.activate(entity: self, context: .stopAdjacent(.right))
        tile.right.activate(entity: self, context: .stopAdjacent(.left))
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
        tile.activate(entity: self, context: .startOn)
        tile.up.activate(entity: self, context: .startAdjacent(.down))
        tile.down.activate(entity: self, context: .startAdjacent(.up))
        tile.left.activate(entity: self, context: .startAdjacent(.right))
        tile.right.activate(entity: self, context: .startAdjacent(.left))

        // Slide Into Activation Context
        var nextTile = getNextTile(direction: direction)
        nextTile.activate(entity: self, context: .slideInto)
        // Loop
        while let direction = slideDirection {
            // Slide Activation Context
            tile = nextTile
            tile.activate(entity: self, context: .slideOn)
            tile.up.activate(entity: self, context: .slideAdjacent(.down))
            tile.down.activate(entity: self, context: .slideAdjacent(.up))
            tile.left.activate(entity: self, context: .slideAdjacent(.right))
            tile.right.activate(entity: self, context: .slideAdjacent(.left))
            // Slide Into Activation Context
            nextTile = getNextTile(direction: direction)
            nextTile.activate(entity: self, context: .slideInto)
        }

        // Stop Activation Context
        tile.activate(entity: self, context: .stopOn)
        tile.up.activate(entity: self, context: .stopAdjacent(.down))
        tile.down.activate(entity: self, context: .stopAdjacent(.up))
        tile.left.activate(entity: self, context: .stopAdjacent(.right))
        tile.right.activate(entity: self, context: .stopAdjacent(.left))
    }

    // Behavior Activation
    func activate(entity: Entity, context: ActivationContext) {
        behavior?.activate(entity: entity, context: context)
    }

    
    func updateState(in level: Level) {
        print("updated player position")
    }
}
