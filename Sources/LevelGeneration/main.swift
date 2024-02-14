func main() {
    let level = Level(levelSize: LevelSize(edgeLength: 8), startingPosition: LevelPoint(face: .bottom, x: 1, y: 1))
    level.setTile(to: Tile(level: level, position: LevelPoint(face: .bottom, x: 1, y: 6), behavior: BendBehavior(directionPair: AdjacentDirectionPair(.right, .up)!)))
    level.setTile(to: DynamicTile(level: level, position: LevelPoint(face: .bottom, x: 7, y: 6), behavior: WallBehavior()))
    level.setTile(to: Tile(level: level, position: LevelPoint(face: .bottom, x: 1, y: 3),
                           behavior: ButtonBehavior(activationBehavior: PortalBehavior(destination: level.tiles[LevelPoint(face: .front, x: 0, y: 1)]!),
                                                    targetTile: level.tiles[LevelPoint(face: .bottom, x: 7, y: 6)] as? DynamicTile)))
    level.setTile(to: Tile(level: level, position: LevelPoint(face: .front, x: 5, y: 1), behavior: StickyBehavior()))
    level.simulatePlayerSlide()
    level.printLevel()
    print(level.player.tile.position)
}
main()
