public struct Level {
    public let levelSize: LevelSize
    public var startingPosition: LevelPoint
    public var faceLevels: [FaceLevel]

    public var levelStates = [LevelState]()
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
        setTileStatus(levelPoint: startingPosition, tileStatus: .critical)
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
        setTileStatus(levelPoint: startingPosition, tileStatus: .critical)
        initializeCriticalTiles()
    }

    // Used to set the state of one or multiple tiles
    public mutating func setTileStatus(levelPoint: LevelPoint, tileStatus: TileStatus) {
        faceLevels[levelPoint.face.rawValue].setTileStatus(levelPoint: levelPoint, tileStatus: tileStatus)
    }
    public mutating func setTileStatus<T: Collection>(levelPoints: T, tileStatus: TileStatus) where T.Element == LevelPoint {
        levelPoints.forEach { setTileStatus(levelPoint: $0, tileStatus: tileStatus) }
    }

    // Used to change the state of one or multiple tiles if they match a current tile state
    public mutating func changeTileStatusIfCurrent(levelPoint: LevelPoint, current currentTileStatus: TileStatus, new newTileStatus: TileStatus) {
        faceLevels[levelPoint.face.rawValue].changeTileStatusIfCurrent(levelPoint: levelPoint, current: currentTileStatus, new: newTileStatus)        
    }
    public mutating func changeTileStatusIfCurrent<T: Collection>(levelPoints: T, current currentTileStatus: TileStatus, new newTileStatus: TileStatus)  where T.Element == LevelPoint {
        levelPoints.forEach { changeTileStatusIfCurrent(levelPoint: $0, current: currentTileStatus, new: newTileStatus) }   
    }

    // Used to set the SpecialTileType of one or multiple tiles
    public mutating func setSpecialTileType(levelPoint: LevelPoint, specialTileType: SpecialTileType?) {
        faceLevels[levelPoint.face.rawValue].setSpecialTileType(levelPoint: levelPoint, specialTileType: specialTileType)
    }
    public mutating func setSpecialTileType<T: Collection>(levelPoints: T, specialTileType: SpecialTileType?) where T.Element == LevelPoint {
        levelPoints.forEach { setSpecialTileType(levelPoint: $0, specialTileType: specialTileType) }
    }

    public func tilePointsOfState(tileStatus: TileStatus) -> Set<LevelPoint> {
        return faceLevels.reduce(Set<LevelPoint>(), { $0.union($1.tilePointsOfState(tileStatus: tileStatus)) })
    }
    public func tilePointsOfType(specialTileType: SpecialTileType?) -> Set<LevelPoint> {
        return faceLevels.reduce(Set<LevelPoint>(), { $0.union($1.tilePointsOfType(specialTileType: specialTileType)) })
    }
    public func tilePointsOfStateAndType(tileStatus: TileStatus, specialTileType: SpecialTileType?) -> Set<LevelPoint> {
        return faceLevels.reduce(Set<LevelPoint>(), { $0.union($1.tilePointsOfStateAndType(tileStatus: tileStatus, specialTileType: specialTileType)) })
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

    public func adjacentState(from origin: SlideState) -> SlideState {
        func handleEdge() -> SlideState {
            guard let (destinationFace,
                       destinationDirection,
                       transformations) = Level.crossEdgeMap[Edge(origin.point.face, origin.direction)] else {
                fatalError("Unexpected edge transformation.")
            }
            let newPoint = transformations.reduce(origin.point,
                                                  { return $1.transform(levelSize: levelSize, newFace: destinationFace, point: $0) })
            return SlideState(point: newPoint, direction: destinationDirection)
        }

        let faceSize = levelSize.faceSize(face: origin.point.face)
        switch origin.direction {
        case .up:
            if origin.point.y - 1 < 0 {
                return handleEdge()
            }
            return SlideState(point: LevelPoint(face: origin.point.face,
                                                 x: origin.point.x,
                                                 y: origin.point.y - 1),
                               direction: origin.direction)
        case .down:
            if origin.point.y + 1 >= faceSize.maxY {
                return handleEdge()
            }
            return SlideState(point: LevelPoint(face: origin.point.face,
                                                 x: origin.point.x,
                                                 y: origin.point.y + 1),
                               direction: origin.direction)
        case .left:
            if origin.point.x - 1 < 0 {
                return handleEdge()
            }
            return SlideState(point: LevelPoint(face: origin.point.face,
                                                 x: origin.point.x - 1,
                                                 y: origin.point.y),
                               direction: origin.direction)
        case .right:
            if origin.point.x + 1 >= faceSize.maxX {
                return handleEdge()
            }
            return SlideState(point: LevelPoint(face: origin.point.face,
                                                 x: origin.point.x + 1,
                                                 y: origin.point.y),                               
                               direction: origin.direction)            
        }
    }

    public func adjacentStates(from levelPoint: LevelPoint) -> [SlideState] {
        return [Direction]([.up, .down, .left, .right]).map { adjacentState(from: SlideState(point: levelPoint, direction: $0)) }
    }

    // Recursively finds ajacentTiles in a direction until SpecialTiles stop the Player
    public func slideTile(origin: SlideState,
                          currentSlideState: SlideState? = nil,
                          intermediates: [SlideState] = []) -> Slide? {

        guard origin != currentSlideState else {
            // If the current player state is the same as the origin, there must be an infite loop and the slide does not exist
            return nil
        }
        
        let start = currentSlideState == nil
        let currentSlideState = currentSlideState ?? origin
        let adjacentSlideState = adjacentState(from: currentSlideState)
        var intermediates = intermediates

        let specialTileType = faceLevels[adjacentSlideState.point.face.rawValue].tiles[adjacentSlideState.point.x][adjacentSlideState.point.y].specialTileType
        // If the adjacent specialTileType is not a wall, player will move forward meaning the current is appended to intermediates
        if specialTileType != .wall && !start {
            intermediates.append(currentSlideState)
        }
        if specialTileType == nil { // No Special Tiles to Process, Slide Normally            
            return slideTile(origin: origin,
                             currentSlideState: adjacentSlideState,
                             intermediates: intermediates)
        }
        switch specialTileType! {
        case .portal(let portalExit):
            // When exiting a portal, the player must exit not on the exit but on its adjacent point
            // because if these portals came in pairs, the player would be infinitely teleported
                
            // Always append the Adjacent State when on a portal
            intermediates.append(adjacentSlideState)
            return slideTile(origin: origin,
                      currentSlideState: SlideState(point: portalExit,
                                                      direction: adjacentSlideState.direction),
                      intermediates: intermediates)            
        case .directionShift(let directionPair):
            guard let shiftedDirection = directionPair.shiftDirection(adjacentSlideState.direction) else {
                // If a nil value was returned, the DirectionShift tile acts as a wall
                fallthrough
            }
            // Continue Recursing, if its not the start of the slide, add the currentSlideState to the intermediates            
            return slideTile(origin: origin,
                      currentSlideState: SlideState(point: adjacentSlideState.point,
                                                      direction: shiftedDirection),
                      intermediates: intermediates)            
        case .wall: // Stops player at previous state
            // A player cannot stop/land on a portal tile, this means that if a portal's adjacent point is a wall,
            // the player would travel back through the portal in the opposite direction
            if case .portal(let portalExit) = faceLevels[currentSlideState.point.face.rawValue].tiles[currentSlideState.point.x][currentSlideState.point.y].specialTileType {
                // Append the CurrentSlideState in both directions to IntermediateSlideStates
                intermediates.append(currentSlideState)
                intermediates.append(SlideState(point: currentSlideState.point,
                                                            direction: currentSlideState.direction.toggle()))
                return slideTile(origin: origin,
                          currentSlideState: SlideState(point: portalExit,
                                                          direction: currentSlideState.direction.toggle()),
                          intermediates: intermediates)
                }
            return Slide(origin: origin,
                         destination: currentSlideState,
                         intermediates: intermediates)
        case .sticky: // Stops player at current state
            return Slide(origin: origin,
                         destination: adjacentSlideState,
                         intermediates: intermediates + [currentSlideState])
        }
    }
    
    mutating func initializeCriticalTiles(criticalTilePoints: Set<LevelPoint>? = nil) {
        let allCriticalTiles = tilePointsOfState(tileStatus: .critical)
        var foundCriticalTilePoints = Set<LevelPoint>()
        for criticalTilePoint in criticalTilePoints ?? allCriticalTiles {            
            for direction in [Direction]([.up, .down, .left, .right]) {
                if let slide = slideTile(origin: SlideState(point: criticalTilePoint, direction: direction)) {
                    if !slide.intermediates.isEmpty || slide.origin.point != slide.destination.point {
                        changeTileStatusIfCurrent(levelPoints: slide.intermediates.map { $0.point }, current: .nonPaintable, new: .paintable)
                        levelGraph.insertSlide(slide)
                        if !allCriticalTiles.contains(slide.destination.point) {
                            setTileStatus(levelPoint: slide.destination.point, tileStatus: .critical)
                            foundCriticalTilePoints.insert(slide.destination.point)
                        }
                    }
                }
            }
        }
        if foundCriticalTilePoints.count > 0 {
            initializeCriticalTiles(criticalTilePoints: foundCriticalTilePoints)
        }
    }

    public func paintableTilePointsAdjacentToCriticals() -> [LevelPoint] {
        let paintableTilePoints = tilePointsOfState(tileStatus: .paintable)
        return paintableTilePoints.filter {
            for direction in [Direction]([.up, .down, .left, .right]) {
                let adjacentPoint = adjacentState(from: SlideState(point: $0, direction: direction)).point
                if faceLevels[adjacentPoint.face.rawValue].tiles[adjacentPoint.x][adjacentPoint.y].tileStatus == .critical {
                    return true
                }
            }
            return false
        }
    }

        // Resets the level to be revalidated
    public mutating func resetLevel() {
        tilePointsOfState(tileStatus: .paintable).forEach { setTileStatus(levelPoint: $0, tileStatus: .nonPaintable) }
        tilePointsOfState(tileStatus: .critical).forEach { setTileStatus(levelPoint: $0, tileStatus: .nonPaintable) }
        levelGraph.clearGraph()
        setTileStatus(levelPoint: startingPosition, tileStatus: .critical)
        initializeCriticalTiles()
    }
    

    // Checks if a level grid is solvable by ensuring that every critical point has a path to the starting position    
    public func solvable() -> Bool {
        for criticalTileGridPoint in tilePointsOfState(tileStatus: .critical) {
            if levelGraph.breadthFirstSearch(origin: criticalTileGridPoint, destination: startingPosition) == nil {
                return false
            }
        }
        return true
    }

}

extension Level: Codable {
    static let version = "2.0.0"
    
    private enum CodingKeys: String, CodingKey {
        case version
        case playerPoint = "player_point"
        case faceTiles = "face_tiles"
        case directionShiftTileData = "direction_shift_tile_data"
        case portalTileData = "portal_tile_data"
        case levelGraph = "level_graph"
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
                        let tileStatus = tile.tileStatus
                        let specialTileType = tile.specialTileType                        
                        if tileStatus == .nonPaintable && specialTileType == nil || specialTileType == .wall {
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
        try container.encode(levelGraph, forKey: .levelGraph)
    }

    static let supportedVersions = ["1.0.0", "1.1.0", "2.0.0"]

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
        let inactiveTilePoints = tilePointsOfState(tileStatus: .nonPaintable)
        let activeTilePoints = tilePointsOfState(tileStatus: .paintable)
        let criticalTilePoints = tilePointsOfState(tileStatus: .critical)
        var emptyLevel = self
        emptyLevel.setSpecialTileType(levelPoints: inactiveTilePoints, specialTileType: .wall)
        emptyLevel.setTileStatus(levelPoints: activeTilePoints.union(criticalTilePoints), tileStatus: .nonPaintable)
        emptyLevel.setTileStatus(levelPoint: emptyLevel.startingPosition, tileStatus: .critical)
        return emptyLevel
    }
}
