public enum EdgeTransformation {
    case maxX
    case maxY
    case minX
    case minY
    case swap
    case invertDeltaY
    case invertDeltaX

    public func transform(levelSize: LevelSize, newFace: Face, point: LevelPoint) -> LevelPoint {
        let newFaceSize = levelSize.faceSize(face: newFace)
        switch self {
        case .maxX:                
            return LevelPoint(face: newFace, x: newFaceSize.maxX - 1, y: point.y)
        case .maxY:
            return LevelPoint(face: newFace, x: point.x, y: newFaceSize.maxY - 1)
        case .minX:
            return LevelPoint(face: newFace, x: 0, y: point.y)
        case .minY:
            return LevelPoint(face: newFace, x: point.x, y: 0)
        case .swap:
            return LevelPoint(face: newFace, x: point.y, y: point.x)
        case .invertDeltaX:
            return LevelPoint(face: newFace, x: newFaceSize.maxX - 1 - point.x, y: point.y)
        case .invertDeltaY:
            return LevelPoint(face: newFace, x: point.x, y: newFaceSize.maxY - 1 - point.y)
        }
    }
}
