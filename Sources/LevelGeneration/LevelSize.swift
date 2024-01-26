public struct LevelSize { // Defines a level size with a length, width, and height
    let length: Int
    let width: Int
    let height: Int

    public init(length:Int, width: Int, height: Int) {
        self.length = length
        self.width = width
        self.height = height
    }

    public init(edgeLength: Int) {
        self.length = edgeLength
        self.width = edgeLength
        self.height = edgeLength
    }

    public func faceSize(cubeFace: CubeFace) -> FaceSize {
        switch cubeFace {
        case .top, .bottom:
            return FaceSize(maxX: length, maxY: width)
        case .front, .back:
            return FaceSize(maxX: width, maxY: height)
        case .right, .left:
            return FaceSize(maxX: length, maxY: height)
        }
    }
}
