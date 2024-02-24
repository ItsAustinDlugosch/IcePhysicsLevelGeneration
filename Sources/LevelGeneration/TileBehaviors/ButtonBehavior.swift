class ButtonBehavior: Behavior {

    weak var targetTile: Tile?
    let activationBehavior: Behavior

    init(activationBehavior: Behavior, targetTile: Tile? = nil) {
        self.activationBehavior = activationBehavior
        self.targetTile = targetTile
    }

    var description: String {
        "Button"
    }

    func activate(entity: Entity, context: ActivationContext) {
        if case .slideOn = context, let targetTile = targetTile {
            targetTile.behavior = activationBehavior
        }
    }
    
}
