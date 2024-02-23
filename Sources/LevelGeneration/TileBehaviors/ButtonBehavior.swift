class ButtonBehavior: Behavior {
    static let activatedBy: [ActivationContext] = [.slideOn]

    weak var targetTile: DynamicTile?
    let activationBehavior: Behavior

    init(activationBehavior: Behavior, targetTile: DynamicTile? = nil) {
        self.activationBehavior = activationBehavior
        self.targetTile = targetTile
    }

    var description: String {
        "Button"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context, let targetTile = targetTile {
            targetTile.dynamicTileBehavior = activationBehavior
        }
    }
    
}
