class ButtonBehavior: TileBehavior {

    weak var targetTile: DynamicTile?
    let activationBehavior: TileBehavior

    init(activationBehavior: TileBehavior, targetTile: DynamicTile? = nil) {
        self.activationBehavior = activationBehavior
        self.targetTile = targetTile
    }

    override var description: String {
        "Button" + super.description
    }

    override func activate(in level: Level, entity: Entity, context: ActivationContext) {
        if case .slideOn = context, let targetTile = targetTile {
            targetTile.dynamicTileBehavior = activationBehavior
        }
    }
    
}
