public class LevelRandomizer {
    public static var shared: LevelRandomizer? = nil
    static let randomizerIterationCap: Int = 10

    private init() {        
    }

    public static func initialize() {
        shared = LevelRandomizer()
    }

    public func createComplexFaceLevels(seed: Level) -> [Level] {
        var levels = [seed]
        var randomizeIterationCount = 0
        
        // Interupt slide with a wall
        func interruptSlides() {
            repeat {            
                precondition(levels.count > 0, "There must be a level seed to randomize")
                var complexLevel = levels[levels.count - 1]
                let viableActiveGridPoints = Set(complexLevel.tilePointsOfStateAndType(tileState: .active)).subtracting(complexLevel.activeTilePointsAdjacentToCriticals())
                guard randomizeIterationCount < LevelRandomizer.randomizerIterationCap else {
                    break
                }
                guard let randomViableActiveGridPoint = viableActiveGridPoints.randomElement() else {
                    break
                }
                complexLevel.setSpecialTileType(levelPoint: randomViableActiveGridPoint, specialTileType: .wall)
                complexLevel.resetLevel()
                if complexLevel.solvable() {                
                    levels.append(complexLevel)
                    randomizeIterationCount = 0
                } else {
                    randomizeIterationCount += 1
                }            
            } while true
        }
        func unlockFace() {
            precondition(levels.count > 0, "There must be a level seed to randomize")
            var complexLevel = levels[levels.count - 1]
            let borderPoints = Set(complexLevel.faceLevels.flatMap { $0.borderPoints() })
            let eligiblePoints = complexLevel.tilePointsOfStateAndType(tileState: .critical).filter {
                let adjacentPoints = Set(complexLevel.adjacentStates(from: $0).map { $0.point })
                // There must be an adjacent point that is also a border tile, sets must not be disjoint
                if adjacentPoints.isDisjoint(with: borderPoints) {
                    return false
                }
                // There must be exactly one wall state                
                let adjacentWallPoints = adjacentPoints.filter { complexLevel.faceLevels[$0.face.rawValue].tiles[$0.x][$0.y].specialTileType == .wall }
                if adjacentWallPoints.count == 1 {
                    return true                    
                }
                return false
            }
            guard let randomEligiblePoint = eligiblePoints.randomElement() else {
                fatalError()
            }
            let adjacentStates = complexLevel.adjacentStates(from: randomEligiblePoint)
            let wallState = adjacentStates.filter {
                complexLevel.faceLevels[$0.point.face.rawValue].tiles[$0.point.x][$0.point.y].specialTileType == .wall
            }[0]
            complexLevel.faceLevels[wallState.point.face.rawValue].tiles[wallState.point.x][wallState.point.y].tileState = .inactive
            let secondAdjacentWallPoint = complexLevel.adjacentState(from: wallState).point
            complexLevel.faceLevels[secondAdjacentWallPoint.face.rawValue].tiles[secondAdjacentWallPoint.x][secondAdjacentWallPoint.y].tileState = .inactive            
            complexLevel.resetLevel()

            func makeSolvableLevel() {
                // An unsolvable level will have a slide within the graph that has a destination that only appears once
                // Find this desitination and add walls that will create a slide(s) that integrate it into the graph
                let isolatedSlides = complexLevel.levelGraph.isolatedSlides()
                print("Isolated count: \(isolatedSlides.count)")
                isolatedSlides.forEach { print($0.destinationPlayerState.point) }
            }
            makeSolvableLevel()
            levels.append(complexLevel)
        }        
        interruptSlides()
        unlockFace()
        return levels        
    }
}    
