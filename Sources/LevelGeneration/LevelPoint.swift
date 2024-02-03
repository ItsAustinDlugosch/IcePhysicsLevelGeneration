public struct LevelPoint: SpecialTileTypeData { // Defines a point with an x and y value
    public let face: Face
    public let x: Int
    public let y: Int

    public init(face: Face, x: Int, y: Int) {
        self.face = face
        self.x = x
        self.y = y
    }
}

extension LevelPoint: Equatable, Hashable {
   
    public static func ==(lhs: LevelPoint, rhs: LevelPoint) -> Bool {
        return lhs.face == rhs.face &&
          lhs.x == rhs.x &&
          lhs.y == rhs.y       
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(face)
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension LevelPoint: Codable {

    private enum CodingKeys: String, CodingKey {
        case face
        case x
        case y
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(face.rawValue, forKey: .face)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let face = try container.decode(Face.self, forKey: .face)
        let x = try container.decode(Int.self, forKey: .x)
        let y = try container.decode(Int.self, forKey: .y)

        self.init(face: face, x: x, y: y)
    }
}
