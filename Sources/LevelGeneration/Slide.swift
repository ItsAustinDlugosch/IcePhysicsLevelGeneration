public struct Slide { // Represents a "slide" that connects two critical points
    public let origin:  SlideState // Where the slide begins
    public let destination: SlideState
    public let intermediates: [SlideState]

    public var full: [SlideState] {
        return [origin] + intermediates + [destination]
    }
    
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

extension Slide: Codable {
    private enum CodingKeys: String, CodingKey {
        case origin
        case destination
        case intermediates
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
        try container.encode(intermediates, forKey: .intermediates)        
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let origin = try container.decode(SlideState.self, forKey: .origin)
        let destination = try container.decode(SlideState.self, forKey: .destination)
        let intermediates = try container.decode([SlideState].self, forKey: .intermediates)
        self.init(origin: origin, destination: destination, intermediates: intermediates)
    }
}
