// Default Tile Behavior
protocol Behavior {
    var description: String { get }
    static var activatedBy: [ActivationContext] { get }
    func activate(entity: Entity, context: ActivationContext)
}
