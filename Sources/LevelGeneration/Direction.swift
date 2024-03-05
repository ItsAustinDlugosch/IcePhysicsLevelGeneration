public enum Direction: String, CaseIterable, Hashable, Codable {
    case up, down, left, right

    public func toggle() -> Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }

    static let clockwiseDirectionPointers: [Direction: Direction] = [
      .up: .right,
      .right: .down,
      .down: .left,
      .left: .up
    ]

    public func clockwiseDistance(from direction: Direction) -> Int {
        var count = 0
        var iterating = direction
        while iterating != self {
            iterating = Direction.clockwiseDirectionPointers[iterating]! // Can safely unwrap because dictionary contains all Directions
            count += 1
        }
        return count
    }
}
