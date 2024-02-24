// Default Tile Behavior
protocol Behavior {
    var description: String { get }
    func activate(entity: Entity, context: ActivationContext)
}
