class Level {

    let levelSize: LevelSize
    let startingPosition: LevelPoint
    var player: Player!
    var faceLevels: [FaceLevel]

    init(levelSize: LevelSize, startingPosition: LevelPoint) {
        self.levelSize = levelSize
        self.startingPosition = startingPosition
        var faceLevels = [FaceLevel]()
        for face in Face.allCases {
            let faceSize = levelSize.faceSize(face: face)
            let faceLevel = FaceLevel(face: face, faceSize: faceSize)
            faceLevels.append(faceLevel)
        }
        self.faceLevels = faceLevels
        setupEdgeTileAdjacency()
        self.player = Player(level: self, startingTile: getTile(at: startingPosition)!)
    }

    // Initializing Functions
    private func setupEdgeTileAdjacency() { // Only sets up adjacency for tiles accross an edge, faces are handled within the FaceLevel        
        
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

    func getTile(at position: LevelPoint) -> Tile? {
        guard position.x >= 0, position.x < faceLevels[position.face.rawValue].tiles.count,
              position.y >= 0, position.y < faceLevels[position.face.rawValue].tiles[position.x].count else {
            return nil
        }
        return faceLevels[position.face.rawValue].tiles[position.x][position.y]            
    }

    func setTile(to newTile: Tile) {
        guard let oldTile = getTile(at: newTile.point) else {
            print("cant set at invalid LevelPoint")
            return
        }
        faceLevels[newTile.point.face.rawValue].tiles[newTile.point.x][newTile.point.y] = newTile
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

    func simulatePlayerSlide() {
        player.slide(.down)        
    }

    func printLevel() {
        for faceIndex in 0 ..< Face.allCases.count {
            print(Face.allCases[faceIndex])
            faceLevels[faceIndex].printFaceLevel()
        }
    }

    
}
