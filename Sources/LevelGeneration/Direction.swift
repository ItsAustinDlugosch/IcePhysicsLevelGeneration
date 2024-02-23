public enum Direction: CaseIterable, Hashable, Codable {
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

    public func isAdjacentTo(_ direction: Direction) -> Bool {
        switch (self, direction) {
        case (.up, .left), (.up, .right),
             (.down, .left), (.down, .right),
             (.left, .up), (.left, .down),
             (.right, .up), (.right, .down):return true
        default:return false
        }
    }
}
