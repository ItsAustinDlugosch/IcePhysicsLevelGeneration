public struct Level {
    public let levelSize: LevelSize
    public let startingPosition: LevelPoint

    public var faceLevels: [FaceLevel]
    public var levelGraph = Graph()
    public init(levelSize: LevelSize, startingPosition: LevelPoint) {
        self.levelSize = levelSize
        self.startingPosition = startingPosition
        
        // Create the face levels
        var faceLevels = [FaceLevel]()
        for face in [Face]([.back, .left, .top, .right, .front, .bottom]) {
            faceLevels.append(FaceLevel(faceSize: levelSize.faceSize(face: face), face: face))
        }
        self.faceLevels = faceLevels
        setTileState(levelPoint: startingPosition, tileState: .critical)
        initializeCriticalTiles()
    }

    public init?(faceLevels: [FaceLevel], startingPosition: LevelPoint) {
        // Face levels must appear in cube face order
        guard faceLevels.map({$0.face}) == Face.allCases else {
            return nil
        }        
        func faceLevelsToLevelSize(_ faceLevels: [FaceLevel]) -> LevelSize? {
            let backFaceLevel = faceLevels[0]
            let leftFaceLevel = faceLevels[1]
            let topFaceLevel = faceLevels[2]
            let rightFaceLevel = faceLevels[3]
            let frontFaceLevel = faceLevels[4]
            let bottomFaceLevel = faceLevels[5]            

            // Ensure length is equal among face levels
            let length = topFaceLevel.faceSize.maxX
            guard length == bottomFaceLevel.faceSize.maxX &&
                    length == leftFaceLevel.faceSize.maxX &&
                    length == rightFaceLevel.faceSize.maxX else {
                print("Length does not match on faces")
                return nil
            }
            // Ensure width is equal among face levels
            let width = topFaceLevel.faceSize.maxY
            guard width == bottomFaceLevel.faceSize.maxY &&
                    width == frontFaceLevel.faceSize.maxX &&
                    width == backFaceLevel.faceSize.maxX else {
                print("Width does not match on faces")
                return nil
            }
            // Ensure height is equal among face levels
            let height = frontFaceLevel.faceSize.maxY
            guard height == backFaceLevel.faceSize.maxY &&
                    height == leftFaceLevel.faceSize.maxY &&
                    height == rightFaceLevel.faceSize.maxY else {
                print("Height does not match on faces")
                return nil
            }
            return LevelSize(length: length, width: width, height: height)
        }
        
        guard let levelSize = faceLevelsToLevelSize(faceLevels) else {
            print("Sizes of face levels are not compatible")
            return nil
        }
        self.levelSize = levelSize
        self.startingPosition = startingPosition
        self.faceLevels = faceLevels
    }

    // Initializing function that is used to set the state of one or multiple tiles
    public mutating func setTileState(levelPoint: LevelPoint, tileState: TileState) {
        faceLevels[levelPoint.face.rawValue].setTileState(levelPoint: levelPoint, tileState: tileState)
    }
    public mutating func setTileState(levelPoints: [LevelPoint], tileState: TileState) {
        levelPoints.forEach { setTileState(levelPoint: $0, tileState: tileState) }
    }

    // Initializing functiona that is used to change the state of one or multiple tiles if they match a current tile state
    public mutating func changeTileStateIfCurrent(levelPoint: LevelPoint, current currentTileState: TileState, new newTileState: TileState) {
        faceLevels[levelPoint.face.rawValue].changeTileStateIfCurrent(levelPoint: levelPoint, current: currentTileState, new: newTileState)        
    }
    public mutating func changeTileStateIfCurrent(levelPoints: [LevelPoint], current currentTileState: TileState, new newTileState: TileState) {
        levelPoints.forEach { changeTileStateIfCurrent(levelPoint: $0, current: currentTileState, new: newTileState) }   
    }

    func tilePointsOfState(tileState: TileState) -> [LevelPoint] {
        return faceLevels.flatMap { $0.tilePointsOfState(tileState: tileState) }
    }

    static let crossEdgeMap: [Edge:(Face, Direction, [EdgeTransformation])] = [
      Edge(.back, .up):(.bottom, .up, [.maxY]),
      Edge(.back, .right):(.right, .down, [.swap, .invertDeltaY, .invertDeltaX]),
      Edge(.back, .down):(.top, .down, [.minY]),
      Edge(.back, .left):(.left, .down, [.swap]),
      Edge(.left, .up):(.back, .right, [.swap]),
      Edge(.left, .right):(.top, .right, [.minX]),
      Edge(.left, .down):(.front, .right, [.swap, .minX]),
      Edge(.left, .left):(.bottom, .right, [.invertDeltaY, .minX]),
      Edge(.top, .up):(.back, .up, [.maxY]),
      Edge(.top, .right):(.right, .right, [.minX]),
      Edge(.top, .down):(.front, .down, [.minY]),
      Edge(.top, .left):(.left, .left, [.maxX]),
      Edge(.right, .up):(.back, .left, [.swap, .maxX]),
      Edge(.right, .right):(.bottom, .left, [.invertDeltaY, .maxX]),
      Edge(.right, .down):(.front, .left, [.swap]),
      Edge(.right, .left):(.top, .left, [.maxX]),
      Edge(.front, .up):(.top, .up, [.maxY]),
      Edge(.front, .right):(.right, .up, [.swap]),
      Edge(.front, .down):(.bottom, .down, [.minY]),
      Edge(.front, .left):(.left, .up, [.swap, .invertDeltaY, .invertDeltaX]),
      Edge(.bottom, .up):(.front, .up, [.maxY]),
      Edge(.bottom, .right):(.right, .left, [.invertDeltaY, .maxX]),
      Edge(.bottom, .down):(.back, .down, [.minY]),
      Edge(.bottom, .left):(.left, .right, [.invertDeltaY, .minX]),
    ]

    public func adjacentPoint(from origin: LevelPoint, direction: Direction) -> (adjacentPoint: LevelPoint, direction: Direction) {        
        func handleEdge() -> (LevelPoint, Direction) {
            guard let (face, direction, transformations) = Level.crossEdgeMap[Edge(origin.face, direction)] else {
                fatalError("Unexpected edge transformation.")
            }
            return (transformations.reduce(origin, { (point: LevelPoint, transformation: EdgeTransformation) -> LevelPoint in
                                                           return transformation.transform(levelSize: levelSize, newFace: face, point: point)
                                                        }), direction)
        }

        let faceSize = levelSize.faceSize(face: origin.face)
        switch direction {
        case .up:
            if origin.y - 1 < 0 { // Transform
                return handleEdge()
            }
            return (LevelPoint(face: origin.face, x: origin.x, y: origin.y - 1), direction)
        case .down:
            if origin.y + 1 >= faceSize.maxY { // Another face
                return handleEdge()
            }
            return (LevelPoint(face: origin.face, x: origin.x, y: origin.y + 1), direction)
        case .left:
            if origin.x - 1 < 0 { // Another face
                return handleEdge()
            }
            return (LevelPoint(face: origin.face, x: origin.x - 1, y: origin.y), direction)
        case .right:
            if origin.x + 1 >= faceSize.maxX {
                return handleEdge()
            }
            return (LevelPoint(face: origin.face, x: origin.x + 1, y: origin.y), direction)
        }
    }

    public func adjacentPoints(levelPoint: LevelPoint) -> [(adjacentPoint: LevelPoint, direction: Direction)] {
        return [Direction]([.up, .down, .left, .right]).map { adjacentPoint(from: levelPoint, direction: $0) }
    }

    public func slideCriticalTile(origin: LevelPoint, direction: Direction) -> Slide {
        let originFaceLevel = faceLevels[origin.face.rawValue]
        precondition(originFaceLevel.tiles[origin.x][origin.y].tileState == .critical,
                     "Tile state must be critical in order to slide.")
        var previous = origin
        var (destination, direction) = adjacentPoint(from: previous, direction: direction)
        var activatedTilePoints = [LevelPoint]()
        while faceLevels[destination.face.rawValue].tiles[destination.x][destination.y].tileState != .wall {
            previous = destination
            activatedTilePoints.append(previous)
            (destination, direction) = adjacentPoint(from: destination, direction: direction)
        }
        return Slide(origin: origin, destination: previous, activatedTilePoints: activatedTilePoints)
    }

    mutating func initializeCriticalTiles(criticalTilePoints: [LevelPoint]? = nil) {
        let allCriticalTiles = tilePointsOfState(tileState: .critical)
        var foundCriticalTilePoints = [LevelPoint]()
        for criticalTilePoint in criticalTilePoints ?? allCriticalTiles {            
            for direction in [Direction]([.up, .down, .left, .right]) {
                let slide = slideCriticalTile(origin: criticalTilePoint, direction: direction)                
                if slide.origin != slide.destination {
                    levelGraph.insertSlide(slide)
                    changeTileStateIfCurrent(levelPoints: slide.activatedTilePoints, current: .inactive, new: .active)
                    if !allCriticalTiles.contains(slide.destination) {
                        setTileState(levelPoint: slide.destination, tileState: .critical)
                        foundCriticalTilePoints.append(slide.destination)
                    }
                }
            }
        }
        if foundCriticalTilePoints.count > 0 {
            initializeCriticalTiles(criticalTilePoints: foundCriticalTilePoints)
        }
    }

    public func activeTilePointsAdjacentToCriticals() -> [LevelPoint] {
        let activeTilePoints = tilePointsOfState(tileState: .active)
        return activeTilePoints.filter {
            for direction in [Direction]([.up, .down, .left, .right]) {
                let adjacentPoint = adjacentPoint(from: $0, direction: direction).adjacentPoint
                if faceLevels[adjacentPoint.face.rawValue].tiles[adjacentPoint.x][adjacentPoint.y].tileState == .critical {
                    return true
                }
            }
            return false
        }
    }

        // Resets the level to be revalidated
    public mutating func resetLevel() {
        tilePointsOfState(tileState: .active).forEach { setTileState(levelPoint: $0, tileState: .inactive) }
        tilePointsOfState(tileState: .critical).forEach { setTileState(levelPoint: $0, tileState: .inactive) }
        levelGraph.clearGraph()
        setTileState(levelPoint: startingPosition, tileState: .critical)
        initializeCriticalTiles()
    }
    

    // Checks if a level grid is solvable by ensuring that every critical point has a path to the starting position    
    public func solvable() -> Bool {
        for criticalTileGridPoint in tilePointsOfState(tileState: .critical) {
            if levelGraph.breadthFirstSearch(origin: criticalTileGridPoint, destination: startingPosition) == nil {
                return false
            }
        }
        return true
    }

    public func printTileStates() {
        for face in [Face]([.back, .left, .top, .right, .front, .bottom]) {
            print(face)
            faceLevels[face.rawValue].printTileStates()
        }              
    }
}

extension Level: Codable {
    static let version = "1.0.0"
    
    private enum CodingKeys: String, CodingKey {
        case version
        case playerPoint = "player_point"
        case faceTiles
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version = try container.decode(String.self, forKey: .version)
        guard version == Level.version else {
            throw DecodingError.dataCorruptedError(forKey: .version, in: container, debugDescription: "Unsuported version: \(version)")
        }
        
        let playerPoint = try container.decode(LevelPoint.self, forKey: .playerPoint)
        let faceTiles = try container.decode([[[Int]]].self, forKey: .faceTiles)

        let faceLevels = try {
            var faceLevels = [FaceLevel]()
            for faceIndex in 0 ..<  Face.allCases.count {
                let intTiles = faceTiles[faceIndex]
                let face = Face.allCases[faceIndex]
                guard let faceLevel = FaceLevel(intTiles: intTiles, face: face) else {
                    throw DecodingError.dataCorruptedError(forKey: .faceTiles, in: container, debugDescription: "Could not create FaceLevels from data")
                }
                faceLevels.append(faceLevel)
            }
            return faceLevels
        }()

        guard let level = Level(faceLevels: faceLevels, startingPosition: playerPoint) else {
            throw DecodingError.dataCorruptedError(forKey: .faceTiles, in: container, debugDescription: "Could not create Level from data")
        }
        self = level
    }
}
