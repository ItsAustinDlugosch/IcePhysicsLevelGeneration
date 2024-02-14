func main() {
    let level = Level(levelSize: LevelSize(edgeLength: 8), startingPosition: LevelPoint(face: .bottom, x: 1, y: 1))
    level.setTile(to: SpecialTile(level: level, position: LevelPoint(face: .bottom, x: 1, y: 6), behavior: BendBehavior(directionPair: AdjacentDirectionPair(.right, .up)!)))
    level.setTile(to: DynamicTile(level: level, position: LevelPoint(face: .bottom, x: 7, y: 6), behavior: WallBehavior()))
    level.setTile(to: SpecialTile(level: level, position: LevelPoint(face: .bottom, x: 1, y: 3), behavior: ButtonBehavior(activationBehavior: PortalBehavior(destination: level.getTile(at: LevelPoint(face: .front, x: 1, y: 1))!), targetTile: level.getTile(at: LevelPoint(face: .bottom, x: 7, y: 6)) as? DynamicTile)))
    level.simulatePlayerSlide()
    level.printLevel()
    print(level.player.tile.position)
}
main()
