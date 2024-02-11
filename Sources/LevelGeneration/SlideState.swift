public struct SlideState { // Represents the state of a slide
    public let point: LevelPoint
    public let direction: Direction

    public init(point: LevelPoint, direction: Direction) {
        self.point = point
        self.direction = direction
    }
}

extension SlideState: Equatable, Hashable {
    public static func ==(lhs: SlideState, rhs: SlideState) -> Bool {
        return lhs.point == rhs.point &&
          lhs.direction == rhs.direction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
        hasher.combine(direction)
    }
}
