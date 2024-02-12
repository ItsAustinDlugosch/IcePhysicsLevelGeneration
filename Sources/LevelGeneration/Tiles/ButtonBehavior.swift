class ButtonBehavior: TileBehavior {

    weak var targetTile: DynamicTile?
    let activationBehavior: TileBehavior

    init(activationBehavior: TileBehavior, targetTile: DynamicTile? = nil) {
        self.activationBehavior = activationBehavior
        self.targetTile = targetTile
    }

    var description: String {
        "Button"
    }

    func activate(by levelMovableObject: LevelMovableObject, in level: Level, context: ActivationContext, direction: Direction) {
        if case .slideOn = context, let targetTile = targetTile {
            targetTile.dynamicBehavior = activationBehavior
        }
    }
    
}
