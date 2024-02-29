public struct Graph { // Represents the relationship between slides on a level grid
    public var slides = Set<Slide>()
    public var originToSlide = [SlideState:Slide]()
    public mutating func insertSlide(_ slide: Slide) {
        slides.insert(slide)
        originToSlide[slide.origin] = slide
    }

    public mutating func clearGraph() {
        slides = []
        originToSlide = [:]
    }
    
    public func breadthFirstSearch(origin: LevelPoint, destination: LevelPoint) -> [Slide]? {
        var stack: [LevelPoint] = [origin]

        enum Visit {
            case origin
            case slide(Slide)
        }

        var visits: Dictionary<LevelPoint, Visit> = [origin: .origin]

        while let currentLevelPoint = stack.popLast() { // Gather a point and remove it from the stack
            if currentLevelPoint == destination { // If we have made it to the destination
                var point = destination // Used to traverse visits dictionary
                var route: [Slide] = [] // route taken to get from origin to destination

                while let visit = visits[point], case .slide(let slide) = visit { // Gather visit from the visits dictionary, must be a slide
                    route = [slide] + route // Prepdestination the slide onto the route, order must be reverse (destination -> origin)                    
                    point = slide.origin.point // change point to the origin of the slide to continue traversing the dictionary
                }
                return route
            }
            // If we haven't made it to the destination, continue to explore slides from current point breadth first
            let slidesFromOrigin = slides.filter { $0.origin.point == currentLevelPoint }
            for slide in slidesFromOrigin {
                if visits[slide.destination.point] == nil { // Only add points to explore if we haven't already visited them
                    stack.append(slide.destination.point) // Add the destination as a place to be explored
                    visits[slide.destination.point] = .slide(slide) // Tell the visits dictionary how we got here
                }
            }
        }
        return nil // Will return nil once all points have been explored and the destination has not been reached
    }

    public func slides(withOriginState origin: SlideState) -> Set<Slide> {
        return slides.filter { $0.origin == origin }
    }

    public func slides(withOriginStates origins: [SlideState]) -> Set<Slide> {
        return slides.filter { origins.contains($0.origin) }
    }

    public func slides(withDestinationState destination: SlideState) -> Set<Slide> {
        return slides.filter { $0.destination == destination }
    }

    public func slides(withDestinationStates destinations: [SlideState]) -> Set<Slide> {
        return slides.filter { destinations.contains($0.destination) }
    }
    
    public func isolatedSlides() -> Set<Slide> {
        let destinationHistogram: [SlideState:Int] = slides.map { $0.destination }.histogram()
        return slides(withDestinationStates: destinationHistogram.allKeysForValue(value: 1))
    }
}

extension Graph: Codable {
    private enum CodingKeys: String, CodingKey {
        case originToSlide = "origin_to_slide"        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(originToSlide, forKey: .originToSlide)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let originToSlide = try container.decode([SlideState:Slide].self, forKey: .originToSlide)
        self.init(slides: Set(originToSlide.values), originToSlide: originToSlide)
    }
}
