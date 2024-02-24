class BendBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideOn]
    
    var directionPair: AdjacentDirectionPair        

    init(directionPair: AdjacentDirectionPair) {
        self.directionPair = directionPair
    }

    var description: String {
        "Bend"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context {
            // Stops motion and acts similar to wall
            entity.slideDirection = directionPair.bendDirection(direction: entity.slideDirection)
        }
    }
}
