class BendBehavior: Behavior {
    var directionPair: AdjacentDirectionPair

    init(directionPair: AdjacentDirectionPair) {
        self.directionPair = directionPair
    }

    var description: String {
        "Bend"
    }

    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?) {
        if case .slideInto = context, let direction = slideDirection {
            // Stops motion and acts similar to wall
            levelMovableObject.slideDirection = directionPair.bendDirection(direction: direction)
        }
    }
}
