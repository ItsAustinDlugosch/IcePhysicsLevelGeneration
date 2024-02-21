class CollisionHandler {

    func testCollision(_ entityOne: Entity, _ entityTwo: Entity) -> Collision? {
        // Ensure the each entity is sliding, and that they are sliding in different directions
        guard let slideDirectionOne = entityOne.slideDirection,
              let nextTileOne = entityOne.nextTile(),
              let slideDirectionTwo = entityTwo.slideDirection,
              let nextTileTwo = entityTwo.nextTile(),
              slideDirectionOne != slideDirectionTwo else {
            return nil
        }
        // Define Collision Context
        let context: CollisionContext = slideDirectionOne == slideDirectionTwo.toggle() ? .headOn : .adjacent
        // Define Collision Type
        let type: CollisionType
        if nextTileOne.position == nextTileTwo.position {
            type = .intersectTile
        } else if nextTileOne.position == entityTwo.position || nextTileTwo.position == entityOne.position {
            type = .intersectTileEdge
        } else {
            return nil
        }

        return Collision(type: type, context: context)
    }

    func handleIntersectCollision(_ entityOne: Entity, _ entityTwo: Entity, activationContext: ActivationContext) {
        let behaviorOne = entityOne.behavior
        let behaviorTwo = entityTwo.behavior
        behaviorOne?.activate(entity: entityTwo, context: .slideInto)
        behaviorTwo?.activate(entity: entityOne, context: .slideInto)
    }

    func handleCollisions(slidingEntities: inout [Entity]) {
        for i in 0 ..< slidingEntities.count {
            for j in (i + 1) ..< slidingEntities.count {
                let slidingEntityOne = slidingEntities[i]
                let slidingEntityTwo = slidingEntities[j]
                if let collision = testCollision(slidingEntityOne, slidingEntityTwo) {
                }
            }
        }
        slidingEntities = slidingEntities.filter { $0.isSliding() }
    }
    
}
