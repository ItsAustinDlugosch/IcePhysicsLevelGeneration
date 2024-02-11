public struct FaceSize: Equatable, Hashable {
    public let maxX: Int
    public let maxY: Int

    public init(maxX: Int, maxY: Int) {
        self.maxX = maxX
        self.maxY = maxY
    }

    public static func ==(lhs: FaceSize, rhs: FaceSize) -> Bool {
        return lhs.maxX == rhs.maxX &&
          lhs.maxY == rhs.maxY
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxX)
        hasher.combine(maxY)
    }
}
