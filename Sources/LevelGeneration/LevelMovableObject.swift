class LevelMovableObject: LevelObject, DynamicFeature {
    // Objects that conform can move within the level, returns whether the move was successful
    var tile: Tile
    var slideDirection: Direction? = nil

    init(level: Level, startingPosition: LevelPoint) {
        guard let startingTile = level.getTile(at: startingPosition) else {
            fatalError("Starting position does not lie on level.")
        }
        self.tile = startingTile
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
        tile.activate(in: level, by: self, context: .startOn, slideDirection: direction)
        tile.up.activate(in: level, by: self, context: .startAdjacent(.down), slideDirection: direction)
        tile.down.activate(in: level, by: self, context: .startAdjacent(.up), slideDirection: direction)
        tile.left.activate(in: level, by: self, context: .startAdjacent(.right), slideDirection: direction)
        tile.right.activate(in: level, by: self, context: .startAdjacent(.left), slideDirection: direction)

        // Slide Into Activation Context
        var nextTile = getNextTile(direction: direction)
        nextTile.activate(in: level, by: self, context: .slideInto, slideDirection: direction)
        // Loop
        while let direction = slideDirection {
            print(nextTile.position)
            // Slide Activation Context
            tile = nextTile
            tile.activate(in: level, by: self, context: .slideOn, slideDirection: direction)
            tile.up.activate(in: level, by: self, context: .slideAdjacent(.down), slideDirection: direction)
            tile.down.activate(in: level, by: self, context: .slideAdjacent(.up), slideDirection: direction)
            tile.left.activate(in: level, by: self, context: .slideAdjacent(.right), slideDirection: direction)
            tile.right.activate(in: level, by: self, context: .slideAdjacent(.left), slideDirection: direction)
            // Slide Into Activation Context
            nextTile = getNextTile(direction: direction)
            nextTile.activate(in: level, by: self, context: .slideInto, slideDirection: direction)
        }

        // Stop Activation Context       
        tile.activate(in: level, by: self, context: .stopOn, slideDirection: direction)
        tile.up.activate(in: level, by: self, context: .stopAdjacent(.down), slideDirection: direction)
        tile.down.activate(in: level, by: self, context: .stopAdjacent(.up), slideDirection: direction)
        tile.left.activate(in: level, by: self, context: .stopAdjacent(.right), slideDirection: direction)
        tile.right.activate(in: level, by: self, context: .stopAdjacent(.left), slideDirection: direction)
    }
    
    func updateState(in level: Level) {
        print("updated player position")
    }
}
