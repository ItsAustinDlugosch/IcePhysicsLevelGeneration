class LevelMovableObject: DynamicFeature {
    // Objects that conform can move within the level, returns whether the move was successful
    var level: Level
    var tile: Tile {
        didSet {
            updateState(in: level)
        }
    }
    var slideDirection: Direction? = nil     

    init(level: Level, startingTile: Tile) {
        self.level = level
        self.tile = startingTile
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
        tile.activate(by: self, in: level, context: .startOn, direction: direction)
        tile.up.activate(by: self, in: level, context: .startAdjacent(.down), direction: direction)
        tile.down.activate(by: self, in: level, context: .startAdjacent(.up), direction: direction)
        tile.left.activate(by: self, in: level, context: .startAdjacent(.right), direction: direction)
        tile.right.activate(by: self, in: level, context: .startAdjacent(.left), direction: direction)

        // Slide Into Activation Context
        var nextTile = getNextTile(direction: direction)
        nextTile.activate(by: self, in: level, context: .slideInto, direction: direction)
        // Loop
        while let direction = slideDirection {
            // Slide Activation Context
            tile = nextTile
            tile.activate(by: self, in: level, context: .slideOn, direction: direction)
            tile.up.activate(by: self, in: level, context: .slideAdjacent(.down), direction: direction)
            tile.down.activate(by: self, in: level, context: .slideAdjacent(.up), direction: direction)
            tile.left.activate(by: self, in: level, context: .slideAdjacent(.right), direction: direction)
            tile.right.activate(by: self, in: level, context: .slideAdjacent(.left), direction: direction)
            // Slide Into Activation Context
            nextTile = getNextTile(direction: direction)
            nextTile.activate(by: self, in: level, context: .slideInto, direction: direction)
        }

        // Stop Activation Context
        tile.activate(by: self, in: level, context: .stopOn, direction: direction)
        tile.up.activate(by: self, in: level, context: .stopAdjacent(.down), direction: direction)
        tile.down.activate(by: self, in: level, context: .stopAdjacent(.up), direction: direction)
        tile.left.activate(by: self, in: level, context: .stopAdjacent(.right), direction: direction)
        tile.right.activate(by: self, in: level, context: .stopAdjacent(.left), direction: direction)
    }
    
    func updateState(in level: Level) {
        print("updated player position")
    }
}
