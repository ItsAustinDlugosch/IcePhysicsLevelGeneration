public struct Slide { // Represents a "slide" that connects two critical points
    public let originPoint: LevelPoint // Where the slide begins
    public let originDirection: Direction // The Direction in which the slide starts    
    public let destinationPoint: LevelPoint // Where the slide ends
    public let destinationDirection: Direction // The Direction in which the slide ends    
    
    public let activatedTilePoints: [LevelPoint] // All of the points along the slide other than the origin and destination

    public init(originPoint: LevelPoint, originDirection: Direction,
                destinationPoint: LevelPoint, destinationDirection: Direction,
                activatedTilePoints: [LevelPoint]) {
        self.originPoint = originPoint
        self.originDirection = originDirection
        self.destinationPoint = destinationPoint
        self.destinationDirection = destinationDirection
        self.activatedTilePoints = activatedTilePoints
    }

    public init(origin: (LevelPoint, Direction), destination: (LevelPoint, Direction), activatedTilePoints: [LevelPoint]) {
        self.originPoint = origin.0
        self.originDirection = origin.1
        self.destinationPoint = destination.0
        self.destinationDirection = destination.1
        self.activatedTilePoints = activatedTilePoints        
    }

}

extension Slide: Hashable, Equatable {    

    public static func ==(lhs: Slide, rhs: Slide) -> Bool {
        return lhs.originPoint == rhs.originPoint &&
          lhs.originDirection == rhs.originDirection &&
          lhs.destinationPoint == rhs.destinationPoint &&
          lhs.destinationDirection == rhs.destinationDirection
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(originPoint)
        hasher.combine(originDirection)
        hasher.combine(destinationPoint)
        hasher.combine(destinationDirection)
    }
}
