func main() {
    let level = Level(levelSize: LevelSize(edgeLength: 9), startingPosition: LevelPoint(face: .bottom, x: 1, y: 1))
    level.setTile(behavior: BendBehavior(directionPair: AdjacentDirectionPair(.right, .up)!), at: LevelPoint(face: .bottom, x: 1, y: 7))
    level.setTile(behavior: BendBehavior(directionPair: AdjacentDirectionPair(.left, .up)!), at: LevelPoint(face: .bottom, x: 7, y: 7))
    level.setTile(behavior: ButtonBehavior(activationBehavior: PortalBehavior(destination: level.tiles[LevelPoint(face: .front, x: 0, y: 1)]!),
                                                   targetTile: level.tiles[LevelPoint(face: .bottom, x: 8, y: 7)]), at: LevelPoint(face: .bottom, x: 1, y: 3))
    level.setTile(behavior: StickyBehavior(), at: LevelPoint(face: .front, x: 5, y: 1))
    level.setTile(behavior: MagnetBehavior(), at: LevelPoint(face: .front, x: 4, y: 2))
    level.addEntity(Player(level: level, position: LevelPoint(face: .bottom, x: 1, y: 1)))
       // let portalEntity = Entity(level: level, position: LevelPoint(face: .bottom, x: 7, y: 1), behavior: PortalBehavior(destination: level.tiles[LevelPoint(face: .front, x: 0, y: 7)]!))
       let wallEntity = Entity(level: level, position: LevelPoint(face: .bottom, x: 6, y: 1), behavior: WallBehavior())
    level.addEntity(wallEntity)
    level.simulateSlide(.down)
    level.printLevel()
    print(level.entities.values.map { $0.currentTile.position })
    print(level.entities.values.map { $0.description })
}
main()
