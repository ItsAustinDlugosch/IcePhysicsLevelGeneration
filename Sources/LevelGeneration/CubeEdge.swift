public struct CubeEdge: Equatable, Hashable {
    public let cubeFace: CubeFace
    public let direction: Direction

    init(_ cubeFace: CubeFace, _ direction: Direction) {
        self.cubeFace = cubeFace
        self.direction = direction
    }

    public static func ==(lhs: CubeEdge, rhs: CubeEdge) -> Bool {
        return lhs.cubeFace == rhs.cubeFace &&
          lhs.direction == rhs.direction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cubeFace)
        hasher.combine(direction)
    }            
}
