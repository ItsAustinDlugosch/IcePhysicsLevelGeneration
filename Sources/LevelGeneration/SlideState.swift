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

extension SlideState: Codable {
    private enum CodingKeys: String, CodingKey {
        case point
        case direction
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(point, forKey: .point)
        try container.encode(direction, forKey: .direction)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let point = try container.decode(LevelPoint.self, forKey: .point)
        let direction = try container.decode(Direction.self, forKey: .direction)
        self.init(point: point, direction: direction)
    }
}
