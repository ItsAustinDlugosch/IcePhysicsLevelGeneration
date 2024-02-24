class Level {

    let levelSize: LevelSize
    let startingPosition: LevelPoint
    var tiles = [LevelPoint:Tile]()
    var entities = [LevelPoint:Entity]()

    init(levelSize: LevelSize, startingPosition: LevelPoint) {
        self.levelSize = levelSize
        self.startingPosition = startingPosition
        var faceLevels = [FaceLevel]()
        // Creating Initializing Class FaceLevels then setup tile adjacency
        for face in Face.allCases {
            let faceSize = levelSize.faceSize(face)
            let faceLevel = FaceLevel(owningLevel: self, face: face, faceSize: faceSize)
            faceLevels.append(faceLevel)
        }

        // Setup EdgeTileAdjacency Initializing Function
        func setupEdgeTileAdjacency() { // Only sets up adjacency for tiles accross an edge, faces are handled within the FaceLevel        
            
            func setEdgeAdjacency(tiles: [Tile], adjacentTiles: [Tile], _ adjacencyDirection: Direction) {
                precondition(tiles.count == adjacentTiles.count)
                for index in 0 ..< tiles.count {
                    switch adjacencyDirection {
                    case .up: tiles[index].up = adjacentTiles[index]
                    case .down: tiles[index].down = adjacentTiles[index]
                    case .left: tiles[index].left = adjacentTiles[index]
                    case .right: tiles[index].right = adjacentTiles[index]
                    }
                }
            }

            // Setup Back Face
            setEdgeAdjacency(tiles: faceLevels[Face.back.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.bottom.rawValue].bottomBorderTiles, .up)
            setEdgeAdjacency(tiles: faceLevels[Face.back.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.top.rawValue].topBorderTiles, .down)
            setEdgeAdjacency(tiles: faceLevels[Face.back.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.left.rawValue].topBorderTiles, .left)
            setEdgeAdjacency(tiles: faceLevels[Face.back.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.right.rawValue].topBorderTiles.reversed(), .right)

            // Setup Left Face
            setEdgeAdjacency(tiles: faceLevels[Face.left.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.back.rawValue].leftBorderTiles, .up)
            setEdgeAdjacency(tiles: faceLevels[Face.left.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.front.rawValue].leftBorderTiles.reversed(), .down)
            setEdgeAdjacency(tiles: faceLevels[Face.left.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.bottom.rawValue].leftBorderTiles.reversed(), .left)
            setEdgeAdjacency(tiles: faceLevels[Face.left.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.top.rawValue].leftBorderTiles, .right)

            // Setup Top Face
            setEdgeAdjacency(tiles: faceLevels[Face.top.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.back.rawValue].bottomBorderTiles, .up)
            setEdgeAdjacency(tiles: faceLevels[Face.top.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.front.rawValue].topBorderTiles, .down)
            setEdgeAdjacency(tiles: faceLevels[Face.top.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.left.rawValue].rightBorderTiles, .left)
            setEdgeAdjacency(tiles: faceLevels[Face.top.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.right.rawValue].leftBorderTiles, .right)

            // Setup Right Face
            setEdgeAdjacency(tiles: faceLevels[Face.right.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.back.rawValue].rightBorderTiles.reversed(), .up)
            setEdgeAdjacency(tiles: faceLevels[Face.right.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.front.rawValue].rightBorderTiles, .down)
            setEdgeAdjacency(tiles: faceLevels[Face.right.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.top.rawValue].rightBorderTiles, .left)
            setEdgeAdjacency(tiles: faceLevels[Face.right.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.bottom.rawValue].rightBorderTiles.reversed(), .right)

            // Setup Front Face
            setEdgeAdjacency(tiles: faceLevels[Face.front.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.top.rawValue].bottomBorderTiles, .up)
            setEdgeAdjacency(tiles: faceLevels[Face.front.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.bottom.rawValue].topBorderTiles, .down)
            setEdgeAdjacency(tiles: faceLevels[Face.front.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.left.rawValue].bottomBorderTiles.reversed(), .left)
            setEdgeAdjacency(tiles: faceLevels[Face.front.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.right.rawValue].bottomBorderTiles, .right)

            // Setup Bottom Face
            setEdgeAdjacency(tiles: faceLevels[Face.bottom.rawValue].topBorderTiles, adjacentTiles: faceLevels[Face.front.rawValue].bottomBorderTiles, .up)
            setEdgeAdjacency(tiles: faceLevels[Face.bottom.rawValue].bottomBorderTiles, adjacentTiles: faceLevels[Face.back.rawValue].topBorderTiles, .down)
            setEdgeAdjacency(tiles: faceLevels[Face.bottom.rawValue].leftBorderTiles, adjacentTiles: faceLevels[Face.left.rawValue].leftBorderTiles.reversed(), .left)
            setEdgeAdjacency(tiles: faceLevels[Face.bottom.rawValue].rightBorderTiles, adjacentTiles: faceLevels[Face.right.rawValue].rightBorderTiles.reversed(), .right)
        }
        
        setupEdgeTileAdjacency()
        // Setup Tiles Dictionary
        faceLevels.forEach { faceLevel in
            faceLevel.tiles.forEach { tileColumn in
                tileColumn.forEach { tile in
                    tiles[tile.position] = tile
                }
            }
        }
    }


    func setTile(behavior: Behavior, at position: LevelPoint) {
        guard let oldTile = tiles[position] else {
            print("Cannot set tile behavior at invalid level point of \(position)")
            return
        }
        let newTile = Tile(level: self, position: position, behavior: behavior)
        tiles[newTile.position] = newTile
        if let upTile = oldTile.up {
            newTile.up = upTile
            upTile.down = newTile
        }
        if let downTile = oldTile.down {
            newTile.down = downTile
            downTile.up = newTile            
        }
        if let leftTile = oldTile.left {
            newTile.left = leftTile
            leftTile.right = newTile
        }
        if let rightTile = oldTile.right {
            newTile.right = rightTile
            rightTile.left = newTile
        }
    }

    func addEntity(_ entity: Entity) {
        guard entities[entity.position] == nil else {
            fatalError("Cannot insert entity where one is already located")
        }
        entities[entity.position] = entity
    }

    func activateLevelObject(at levelPoint: LevelPoint, entity: Entity, context: ActivationContext) {
        guard let tile = tiles[levelPoint] else {
            fatalError("LevelPoint out of range")            
        }
        let levelObject: LevelObject = entities[levelPoint] ?? tile
        levelObject.behavior?.activate(entity: entity, context: context)
    }
    func activateTile(at levelPoint: LevelPoint, entity: Entity, context: ActivationContext) {
        guard let tile = tiles[levelPoint] else {
            fatalError("LevelPoint out of range")
        }
        tile.behavior?.activate(entity: entity, context: context)
    }
    func performCollisionBetween(_ entityOne: Entity, and entityTwo: Entity) {
        // First activate each behavior onto the other with .slideInto context        
        entityOne.behavior?.activate(entity: entityTwo, context: .slideInto)
        entityTwo.behavior?.activate(entity: entityOne, context: .slideInto)
        // Then activate each behavior onto the other with .slideOn context
        entityOne.behavior?.activate(entity: entityTwo, context: .slideOn)
        entityTwo.behavior?.activate(entity: entityOne, context: .slideOn)
    }

    func simulateSlide(_ direction: Direction) {
        var slidingEntities = Array(entities.values)
        var nextTiles = [Tile]()
        for (entityIndex, entity) in slidingEntities.enumerated() {
            entity.slideDirection = direction
            // Start Slide Activation
            activateTile(at: entity.currentTile.position, entity: entity, context: .startOn)
            activateLevelObject(at: entity.currentTile.up.position, entity: entity, context: .startAdjacent(.down))
            activateLevelObject(at: entity.currentTile.down.position, entity: entity, context: .startAdjacent(.up))
            activateLevelObject(at: entity.currentTile.left.position, entity: entity, context: .startAdjacent(.right))
            activateLevelObject(at: entity.currentTile.right.position, entity: entity, context: .startAdjacent(.left))
            if let nextTile = entity.nextTile() {
                nextTiles.append(nextTile)
                activateLevelObject(at: nextTile.position, entity: entity, context: .slideInto)
            } else {
                slidingEntities.remove(at: entityIndex)
            }
        }

        func filterSliding() {
            // Filter for the entities that are still sliding and remove at indices accordingly
            precondition(slidingEntities.count == nextTiles.count, "Number of sliding entities was unexpectedly not equal to number of next tiles")
            var filteredIndices = [Int]()
            for index in 0 ..< slidingEntities.count {
                if !slidingEntities[index].isSliding() {
                    filteredIndices.append(index)
                }
            }
            filteredIndices.forEach {
                slidingEntities.remove(at: $0)
                nextTiles.remove(at: $0)
            }
        }
        filterSliding()

        func testCollisions() {        
            for i in 0 ..< slidingEntities.count {
                for j in (i + 1) ..< slidingEntities.count {
                    // Tiles at i and j are the same instance, so access corresponding entities
                    if nextTiles[i] === nextTiles[j] {
                        let entity1 = slidingEntities[i]
                        let entity2 = slidingEntities[j]
                        // Perform collision check or operation with entity1 and entity2
                        performCollisionBetween(entity1, and: entity2)
                    }
                }
            }
        }
        
        testCollisions()
        filterSliding()

        while slidingEntities.count > 0 {

            // Clear out next tiles
            nextTiles = []
            
            slidingEntities.forEach { entity in
                // Get next tile to advance the location of everyobject
                guard let nextFrameTile = entity.nextTile() else {
                    fatalError("Expected entity to be sliding.")
                }
                entities[entity.currentTile.position] = nil
                entities[nextFrameTile.position] = entity
                entity.currentTile = nextFrameTile
            }
            for (entityIndex, entity) in slidingEntities.enumerated() {
                activateTile(at: entity.currentTile.position, entity: entity, context: .slideOn)
                activateLevelObject(at: entity.currentTile.up.position, entity: entity, context: .slideAdjacent(.down))
                activateLevelObject(at: entity.currentTile.down.position, entity: entity, context: .slideAdjacent(.up))
                activateLevelObject(at: entity.currentTile.left.position, entity: entity, context: .slideAdjacent(.right))
                activateLevelObject(at: entity.currentTile.right.position, entity: entity, context: .slideAdjacent(.left))

                if let nextTile = entity.nextTile() {
                    nextTiles.append(nextTile)
                    activateLevelObject(at: nextTile.position, entity: entity, context: .slideInto)
                } else {
                    slidingEntities.remove(at: entityIndex)
                }
            }
            filterSliding()
            testCollisions()
            filterSliding()
            
        }

        slidingEntities.forEach { entity in
            activateTile(at: entity.currentTile.position, entity: entity, context: .stopOn)
            activateLevelObject(at: entity.currentTile.up.position, entity: entity, context: .stopAdjacent(.down))
            activateLevelObject(at: entity.currentTile.down.position, entity: entity, context: .stopAdjacent(.up))
            activateLevelObject(at: entity.currentTile.left.position, entity: entity, context: .stopAdjacent(.right))
            activateLevelObject(at: entity.currentTile.right.position, entity: entity, context: .stopAdjacent(.left))
        }
        
    }
}

extension Level {
    func printLevel() {
        for face in Face.allCases {
            print(face)
            let faceSize = levelSize.faceSize(face)
            // Swap x and y to print rows rather than columns            
            for y in 0 ..< faceSize.maxX {
                var tileDescriptions: [String] = []
                for x in 0 ..< faceSize.maxY {
                    let position = LevelPoint(face: face, x: x, y: y)
                    guard let description = tiles[position]?.description else {
                        fatalError("Unable to find tile at contained LevelPoint of \(position)")
                    }
                    tileDescriptions.append(description)
                }
                print(tileDescriptions)
            }            
        }
    }
}
