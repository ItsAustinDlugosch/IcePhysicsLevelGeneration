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


    func setTileBehavior(behavior: TileBehavior, at position: LevelPoint, dynamic: Bool = false) {
        guard let oldTile = tiles[position] else {
            print("Cannot set tile behavior at invalid level point of \(position)")
            return
        }
        let newTile = dynamic ? DynamicTile(level: self, position: position, behavior: behavior) : Tile(level: self, position: position, behavior: behavior)
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
        guard let tile = tiles[entity.position], tile.entity == nil else {
            print("Cannot add entity because the tile at \(entity.position) is already occupied or does not exist.")
            return
        }
        tile.entity = entity
        entities[entity.position] = entity
    }

    func simulateSlide(_ direction: Direction) {
        for entity in entities.values {
            entity.slide(direction)
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
