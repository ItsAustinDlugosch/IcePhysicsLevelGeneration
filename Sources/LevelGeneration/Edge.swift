public struct Edge: Equatable, Hashable {
    public let face: Face
    public let direction: Direction

    public init(_ face: Face, _ direction: Direction) {
        self.face = face
        self.direction = direction
    }

    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.face == rhs.face &&
          lhs.direction == rhs.direction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(face)
        hasher.combine(direction)
    }            
}
