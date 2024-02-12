class BendBehavior: TileBehavior {
    var directionPair: AdjacentDirectionPair

    init(directionPair: AdjacentDirectionPair) {
        self.directionPair = directionPair
    }

    var description: String {
        "Bend"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        if case .slideInto = context {
            // Stops motion and acts similar to wall
            levelMovableObject.slideDirection = directionPair.bendDirection(direction: direction)
        }
    }
}
