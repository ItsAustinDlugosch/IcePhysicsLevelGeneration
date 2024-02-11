public struct PlayerState { // Represents the state of a player when starting, during, and ending a Slide
    public let point: LevelPoint
    public let direction: Direction
}

extension PlayerState: Equatable, Hashable {
    public static func ==(lhs: PlayerState, rhs: PlayerState) -> Bool {
        return lhs.point == rhs.point &&
          lhs.direction == rhs.direction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
        hasher.combine(direction)
    }
}
