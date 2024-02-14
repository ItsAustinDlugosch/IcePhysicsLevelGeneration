class ButtonBehavior: Behavior {

    weak var targetTile: DynamicTile?
    let activationBehavior: Behavior

    init(activationBehavior: Behavior, targetTile: DynamicTile? = nil) {
        self.activationBehavior = activationBehavior
        self.targetTile = targetTile
    }

    var description: String {
        "Button"
    }

    func activate(in level: Level, by levelMovableObject: LevelMovableObject,
                  context: ActivationContext, slideDirection: Direction?) {
        if case .slideOn = context, let targetTile = targetTile {
            targetTile.dynamicBehavior = activationBehavior
        }
    }
    
}
