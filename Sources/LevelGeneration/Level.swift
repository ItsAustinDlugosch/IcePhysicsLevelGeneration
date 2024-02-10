public struct Level {
    public let levelSize: LevelSize
    public var startingPosition: LevelPoint

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
        setTileState(levelPoint: startingPosition, tileState: .critical)
        initializeCriticalTiles()
    }

    // Used to set the state of one or multiple tiles
    public mutating func setTileState(levelPoint: LevelPoint, tileState: TileState) {
        faceLevels[levelPoint.face.rawValue].setTileState(levelPoint: levelPoint, tileState: tileState)
    }
    public mutating func setTileState(levelPoints: [LevelPoint], tileState: TileState) {
        levelPoints.forEach { setTileState(levelPoint: $0, tileState: tileState) }
    }

    // Used to change the state of one or multiple tiles if they match a current tile state
    public mutating func changeTileStateIfCurrent(levelPoint: LevelPoint, current currentTileState: TileState, new newTileState: TileState) {
        faceLevels[levelPoint.face.rawValue].changeTileStateIfCurrent(levelPoint: levelPoint, current: currentTileState, new: newTileState)        
    }
    public mutating func changeTileStateIfCurrent(levelPoints: [LevelPoint], current currentTileState: TileState, new newTileState: TileState) {
        levelPoints.forEach { changeTileStateIfCurrent(levelPoint: $0, current: currentTileState, new: newTileState) }   
    }

    // Used to set the SpecialTileType of one or multiple tiles
    public mutating func setSpecialTileType(levelPoint: LevelPoint, specialTileType: SpecialTileType?) {
        faceLevels[levelPoint.face.rawValue].setSpecialTileType(levelPoint: levelPoint, specialTileType: specialTileType)
    }
    public mutating func setSpecialTileType(levelPoints: [LevelPoint], specialTileType: SpecialTileType?) {
        levelPoints.forEach { setSpecialTileType(levelPoint: $0, specialTileType: specialTileType) }
    }

    public func tilePointsOfStateAndType(tileState: TileState, specialTileType: SpecialTileType? = nil) -> [LevelPoint] {
        return faceLevels.flatMap { $0.tilePointsOfStateAndType(tileState: tileState, specialTileType: specialTileType) }
    }

    static let crossEdgeMap: [Edge:(Face, Direction, [EdgeTransformation])] = [
      Edge(.back, .up):(.bottom, .up, [.maxY]),
      Edge(.back, .right):(.right, .down, [.invertDeltaY, .swap, .minY]),
      Edge(.back, .down):(.top, .down, [.minY]),
      Edge(.back, .left):(.left, .down, [.swap, .minY]),
      Edge(.left, .up):(.back, .right, [.swap]),
      Edge(.left, .right):(.top, .right, [.minX]),
      Edge(.left, .down):(.front, .right, [.invertDeltaX, .swap, .minX]),
      Edge(.left, .left):(.bottom, .right, [.invertDeltaY, .minX]),
      Edge(.top, .up):(.back, .up, [.maxY]),
      Edge(.top, .right):(.right, .right, [.minX]),
      Edge(.top, .down):(.front, .down, [.minY]),
      Edge(.top, .left):(.left, .left, [.maxX]),
      Edge(.right, .up):(.back, .left, [.invertDeltaX, .swap, .maxX]),
      Edge(.right, .right):(.bottom, .left, [.invertDeltaY, .maxX]),
      Edge(.right, .down):(.front, .left, [.swap]),
      Edge(.right, .left):(.top, .left, [.maxX]),
      Edge(.front, .up):(.top, .up, [.maxY]),
      Edge(.front, .right):(.right, .up, [.swap, .maxY]),
      Edge(.front, .down):(.bottom, .down, [.minY]),
      Edge(.front, .left):(.left, .up, [.invertDeltaY, .swap, .maxY]),
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

    public mutating func slideTile(originPoint: LevelPoint, originDirection: Direction) -> Slide? {
        var previous = originPoint
        var (destination, direction) = adjacentPoint(from: previous, direction: originDirection)
        var activatedTilePoints = [LevelPoint]()
        while faceLevels[destination.face.rawValue].tiles[destination.x][destination.y].specialTileType != .wall {
            guard originPoint != destination || originDirection != direction else {
                // When special tiles that change the state of the grid are added
                return nil
            }
            switch faceLevels[destination.face.rawValue].tiles[destination.x][destination.y].specialTileType {
            case nil:
                previous = destination
                activatedTilePoints.append(destination)            
                (destination, direction) = adjacentPoint(from: destination, direction: direction)
            case .directionShift(let directionPair):
                guard let shiftedDirection = directionPair.shiftDirection(direction) else {
                    return Slide(originPoint: originPoint, originDirection: originDirection, destinationPoint: previous, destinationDirection: direction, activatedTilePoints: activatedTilePoints)
                }
                previous = destination
                activatedTilePoints.append(destination)            
                (destination, direction) = adjacentPoint(from: destination, direction: shiftedDirection)
            case .portal(let portalExit):
                previous = destination
                activatedTilePoints.append(destination)
                activatedTilePoints.append(portalExit)            
                (destination, direction) = adjacentPoint(from: portalExit, direction: direction)
                // Portal logic, when stopping on a portal, go backwards through portal in opposite direction
                if case .wall = faceLevels[destination.face.rawValue].tiles[destination.x][destination.y].specialTileType,
                   case .portal(let newPortalExit) = faceLevels[previous.face.rawValue].tiles[previous.x][previous.y].specialTileType {
                    (destination, direction) = adjacentPoint(from: newPortalExit, direction: direction.toggle())                    
                }
                   case .sticky:
                       return Slide(originPoint: originPoint, originDirection: originDirection, destinationPoint: previous, destinationDirection: direction, activatedTilePoints: activatedTilePoints)
                       
            default:
                fatalError("Unexpectedly found wall at destination")
            }
        }
        return Slide(originPoint: originPoint, originDirection: originDirection, destinationPoint: previous, destinationDirection: direction, activatedTilePoints: activatedTilePoints)
    }

    mutating func initializeCriticalTiles(criticalTilePoints: [LevelPoint]? = nil) {
        let allCriticalTiles = tilePointsOfStateAndType(tileState: .critical)
        var foundCriticalTilePoints = [LevelPoint]()
        for criticalTilePoint in criticalTilePoints ?? allCriticalTiles {            
            for direction in [Direction]([.up, .down, .left, .right]) {
                if let slide = slideTile(originPoint: criticalTilePoint, originDirection: direction) {
                    if !slide.activatedTilePoints.isEmpty {
                        changeTileStateIfCurrent(levelPoints: slide.activatedTilePoints, current: .inactive, new: .active)
                        levelGraph.insertSlide(slide)
                        if !allCriticalTiles.contains(slide.destinationPoint) {
                            setTileState(levelPoint: slide.destinationPoint, tileState: .critical)
                            foundCriticalTilePoints.append(slide.destinationPoint)
                        }
                    }
                }
            }
        }
        if foundCriticalTilePoints.count > 0 {
            initializeCriticalTiles(criticalTilePoints: foundCriticalTilePoints)
        }
    }

    public func activeTilePointsAdjacentToCriticals() -> [LevelPoint] {
        let activeTilePoints = tilePointsOfStateAndType(tileState: .active)
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
        tilePointsOfStateAndType(tileState: .active).forEach { setTileState(levelPoint: $0, tileState: .inactive) }
        tilePointsOfStateAndType(tileState: .critical).forEach { setTileState(levelPoint: $0, tileState: .inactive) }
        levelGraph.clearGraph()
        setTileState(levelPoint: startingPosition, tileState: .critical)
        initializeCriticalTiles()
    }
    

    // Checks if a level grid is solvable by ensuring that every critical point has a path to the starting position    
    public func solvable() -> Bool {
        for criticalTileGridPoint in tilePointsOfStateAndType(tileState: .critical) {
            if levelGraph.breadthFirstSearch(origin: criticalTileGridPoint, destination: startingPosition) == nil {
                return false
            }
        }
        return true
    }

    public func printLevel() {
        for face in [Face]([.back, .left, .top, .right, .front, .bottom]) {
            print(face)
            faceLevels[face.rawValue].printFaceLevel()
        }              
    }
}

extension Level: Codable {
    static let version = "1.1.0"
    
    private enum CodingKeys: String, CodingKey {
        case version
        case playerPoint = "player_point"
        case faceTiles = "face_tiles"
        case directionShiftTileData = "direction_shift_tile_data"
        case portalTileData = "portal_tile_data"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Level.version, forKey: .version)
        try container.encode(startingPosition, forKey: .playerPoint)
        var directionShiftTileData = [LevelPoint: DirectionPair]()
        var portalTileData = [LevelPoint: LevelPoint]()
        let intTiles: [[[Int]]] = {
            faceLevels.map { faceLevel in
                faceLevel.tiles.map { tileColumn in
                    tileColumn.map { tile in
                        let tileState = tile.tileState
                        let specialTileType = tile.specialTileType                        
                        if tileState == .inactive && specialTileType == nil || specialTileType == .wall {
                            return 1
                        }
                        if case .directionShift(let directionPair) = specialTileType {
                            directionShiftTileData[tile.point] = directionPair
                            return 2                            
                        }
                        if case .portal(let portalExit) = specialTileType {
                            portalTileData[tile.point] = portalExit
                            return 3
                        }
                        if case .sticky = specialTileType {
                            return 4
                        }
                        return 0
                    }
                }
            }
        }()
        try container.encode(intTiles, forKey: .faceTiles)
        try container.encode(directionShiftTileData, forKey: .directionShiftTileData)
        try container.encode(portalTileData, forKey: .portalTileData)
    }

    static let supportedVersions = ["1.0.0", "1.1.0"]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version = try container.decode(String.self, forKey: .version)
        guard Level.supportedVersions.contains(version) else {
            throw DecodingError.dataCorruptedError(forKey: .version, in: container, debugDescription: "Unsuported version: \(version)")
        }
        
        let playerPoint = try container.decode(LevelPoint.self, forKey: .playerPoint)
        let faceTiles = try container.decode([[[Int]]].self, forKey: .faceTiles)
        let directionShiftTileData = try container.decodeIfPresent([LevelPoint: DirectionPair].self, forKey: .directionShiftTileData) ?? [LevelPoint: DirectionPair]()
        let portalTileData = try container.decodeIfPresent([LevelPoint: LevelPoint].self, forKey: .portalTileData) ?? [LevelPoint: LevelPoint]()

        let faceLevels = try {
            var faceLevels = [FaceLevel]()
            for faceIndex in 0 ..<  Face.allCases.count {
                let intTiles = faceTiles[faceIndex]
                let face = Face.allCases[faceIndex]
                
                var specialTileData = [LevelPoint: any SpecialTileTypeData]()
                directionShiftTileData.forEach { (key, value) in specialTileData[key] = value }
                portalTileData.forEach { (key, value) in specialTileData[key] = value }
                
                guard let faceLevel = FaceLevel(intTiles: intTiles, specialTileData: specialTileData, face: face) else {
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

extension Level {
    public var associatedSpecialData: [LevelPoint: any SpecialTileTypeData] {
            var associatedSpecialData = [LevelPoint: any SpecialTileTypeData]()
            for faceLevel in faceLevels {
                for tileColumn in faceLevel.tiles {
                    for tile in tileColumn {
                        if case .directionShift(let directionPair) = tile.specialTileType {
                            associatedSpecialData[tile.point] = directionPair
                        }
                        if case .portal(let destination) = tile.specialTileType {
                            associatedSpecialData[tile.point] = destination
                        }                    
                    }
                }
            }
            return associatedSpecialData
    }
    public var portalExitLocations: [LevelPoint] {
        return associatedSpecialData.compactMap { (tilePoint, associatedSpecialData) in
            if case .portal = faceLevels[tilePoint.face.rawValue].tiles[tilePoint.x][tilePoint.y].specialTileType {
                return associatedSpecialData as? LevelPoint
            }
            return nil
        }    
    }

    public func emptyLevel() -> Level {
        let inactiveTilePoints = tilePointsOfStateAndType(tileState: .inactive)
        let activeTilePoints = tilePointsOfStateAndType(tileState: .active)
        let criticalTilePoints = tilePointsOfStateAndType(tileState: .critical)
        var emptyLevel = self
        emptyLevel.setSpecialTileType(levelPoints: inactiveTilePoints, specialTileType: .wall)
        emptyLevel.setTileState(levelPoints: activeTilePoints + criticalTilePoints, tileState: .inactive)
        emptyLevel.setTileState(levelPoint: emptyLevel.startingPosition, tileState: .critical)
        return emptyLevel
    }
}
