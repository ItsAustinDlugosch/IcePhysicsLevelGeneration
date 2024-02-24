class LevelObject: CustomStringConvertible {
    let level: Level
    let position: LevelPoint
    var behavior: Behavior?

    init(level: Level, position: LevelPoint, behavior: Behavior? = nil) {
        self.level = level
        self.position = position
        self.behavior = behavior
    }

    var description: String {
        "Level Object at position \(position)"
    }

}
