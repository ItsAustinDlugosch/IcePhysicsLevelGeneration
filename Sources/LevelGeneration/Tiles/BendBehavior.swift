class BendBehavior: TileBehavior {
    var directionPair: AdjacentDirectionPair

    init(directionPair: AdjacentDirectionPair) {
        self.directionPair = directionPair
    }

    override var description: String {
        "Bend" + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        if case .slideInto = context {
            // Stops motion and acts similar to wall
            entity.slideDirection = directionPair.bendDirection(direction: entity.slideDirection)
        }
    }
}
