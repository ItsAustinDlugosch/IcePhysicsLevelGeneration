class MagnetBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideAdjacent(.up), .slideAdjacent(.down), .slideAdjacent(.left), .slideAdjacent(.right), .slideInto]

    var description: String {
        "Magnet"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideAdjacent = context {
            entity.slideDirection = nil
        }
    }
    
}
