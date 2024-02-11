public struct Slide { // Represents a "slide" that connects two critical points
    public let origin:  SlideState // Where the slide begins
    public let destination: SlideState
    public let intermediates: [SlideState]
    

    public init(origin: SlideState,
                destination: SlideState,
                intermediates: [SlideState]) {
        self.origin = origin
        self.destination = destination
        self.intermediates = intermediates
    }
}

extension Slide: Hashable, Equatable {    

    public static func ==(lhs: Slide, rhs: Slide) -> Bool {
        return lhs.origin == rhs.origin &&
          lhs.destination == rhs.destination 
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin)
        hasher.combine(destination)
    }
}
