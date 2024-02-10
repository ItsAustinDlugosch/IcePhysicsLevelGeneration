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
                let adjacentPoints = Set(complexLevel.adjacentPoints(levelPoint: $0).map { $0.adjacentPoint })
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
            let adjacentPoints = complexLevel.adjacentPoints(levelPoint: randomEligiblePoint)
            let (adjacentWallPoint, direction) = adjacentPoints.filter {
                complexLevel.faceLevels[$0.adjacentPoint.face.rawValue].tiles[$0.adjacentPoint.x][$0.adjacentPoint.y].specialTileType == .wall
            }[0]
            complexLevel.faceLevels[adjacentWallPoint.face.rawValue].tiles[adjacentWallPoint.x][adjacentWallPoint.y].tileState = .inactive
            let secondAdjacentWallPoint = complexLevel.adjacentPoint(from: adjacentWallPoint, direction: direction).adjacentPoint
            complexLevel.faceLevels[secondAdjacentWallPoint.face.rawValue].tiles[secondAdjacentWallPoint.x][secondAdjacentWallPoint.y].tileState = .inactive            
            complexLevel.resetLevel()

            func makeSolvableLevel() {
                // An unsolvable level will have a slide within the graph that has a destination that only appears once
                // Find this desitination and add walls that will create a slide(s) that integrate it into the graph
                let isolatedSlides = complexLevel.levelGraph.isolatedSlides()
                print("Isolated count: \(isolatedSlides.count)")
                isolatedSlides.forEach { print($0.destinationPoint) }
            }
            makeSolvableLevel()
            levels.append(complexLevel)
        }        
        interruptSlides()
        unlockFace()
        return levels        
    }
}    
