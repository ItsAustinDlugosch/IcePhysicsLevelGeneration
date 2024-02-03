public enum TileState: CustomStringConvertible {
    case critical // Represents a tile that the player can land on, sub set of active tiles
    case active // Represents a tile that the player can "paint" (slide over/land on)
    case inactive // Represents a tile that is not able to be activated by the player

    public var description: String {
        switch self {
        case .critical:
            return "critical"
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        }
    }
}
