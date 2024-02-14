func main() {
    let level = Level(levelSize: LevelSize(edgeLength: 8), startingPosition: LevelPoint(face: .bottom, x: 1, y: 1))
    level.setTileBehavior(behavior: BendBehavior(directionPair: AdjacentDirectionPair(.right, .up)!), at: LevelPoint(face: .bottom, x: 1, y: 6))
    level.setTileBehavior(behavior: WallBehavior(), at: LevelPoint(face: .bottom, x: 7, y: 6), dynamic: true)
    level.setTileBehavior(behavior: ButtonBehavior(activationBehavior: PortalBehavior(destination: level.tiles[LevelPoint(face: .front, x: 0, y: 1)]!),
                                                   targetTile: level.tiles[LevelPoint(face: .bottom, x: 7, y: 6)] as? DynamicTile), at: LevelPoint(face: .bottom, x: 1, y: 3))
    level.setTileBehavior(behavior: StickyBehavior(), at: LevelPoint(face: .front, x: 5, y: 1))
    level.addEntity(Player(level: level, startingPosition: LevelPoint(face: .bottom, x: 1, y: 1)))
    level.simulateSlide(.down)
    level.printLevel()
    print(level.entities)
}
main()
