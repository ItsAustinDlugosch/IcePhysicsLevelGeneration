public enum Direction: Hashable, Codable {
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
}
