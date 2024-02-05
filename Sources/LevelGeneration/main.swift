func main() {

    var level = Level(levelSize: LevelSize(edgeLength: 7), startingPosition: LevelPoint(face: .back, x: 1, y: 1))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .back, x: 3, y: 5), specialTileType: .directionShift(pair: DirectionPair(.right, .down)))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .back, x: 3, y: 3), specialTileType: .portal(to: LevelPoint(face: .top, x: 1, y: 5)))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .top, x: 1, y: 5), specialTileType: .portal(to: LevelPoint(face: .back, x: 3, y: 3)))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .top, x: 1, y: 4), specialTileType: .directionShift(pair: DirectionPair(.up, .left)))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .top, x: 2, y: 4), specialTileType: .directionShift(pair: DirectionPair(.up, .right)))
    level.setSpecialTileType(levelPoint: LevelPoint(face: .top, x: 2, y: 5), specialTileType: .directionShift(pair: DirectionPair(.down, .right)))
    level.resetLevel()
    level.printLevel()
    print(level.solvable())
    
}
main()
