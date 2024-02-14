protocol Behavior: CustomStringConvertible {
    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?)
}
