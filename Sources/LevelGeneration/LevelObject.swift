class LevelObject: CustomStringConvertible {
    let level: Level
    let position: LevelPoint

    init(level: Level, position: LevelPoint) {
        self.level = level
        self.position = position
    }

    var description: String {
        "Level Object at position \(position)"
    }

}
