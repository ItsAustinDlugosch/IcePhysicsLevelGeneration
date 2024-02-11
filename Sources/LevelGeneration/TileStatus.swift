public enum TileStatus: CustomStringConvertible {
    case critical // Represents a tile that the player can land on, sub set of active tiles
    case paintable // Represents a tile that the player can "paint" (slide over/land on)
    case nonPaintable // Represents a tile that is not able to be painted by the player

    public var description: String {
        switch self {
        case .critical:
            return "critical"
        case .paintable:
            return "active"
        case .nonPaintable:
            return "inactive"
        }
    }
}
