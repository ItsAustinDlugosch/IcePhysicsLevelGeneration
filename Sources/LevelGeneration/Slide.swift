public struct Slide { // Represents a "slide" that connects two critical points
    public let originPlayerState:  PlayerState // Where the slide begins
    public let destinationPlayerState: PlayerState
    public let intermediatePlayerStates: [PlayerState]
    

    public init(originPlayerState: PlayerState,
                destinationPlayerState: PlayerState,
                intermediatePlayerState: [PlayerState]) {
        self.originPlayerState = originPlayerState
        self.destinationPlayerState = destinationPlayerState
        self.intermediatePlayerStates = intermediatePlayerState
    }
}

extension Slide: Hashable, Equatable {    

    public static func ==(lhs: Slide, rhs: Slide) -> Bool {
        return lhs.originPlayerState == rhs.originPlayerState &&
          lhs.destinationPlayerState == rhs.destinationPlayerState 
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(originPlayerState)
        hasher.combine(destinationPlayerState)
    }
}
