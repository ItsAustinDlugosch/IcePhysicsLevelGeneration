struct AdjacentDirectionPair {
    let exitOne: Direction
    let exitTwo: Direction

    init?(_ exitOne: Direction, _ exitTwo: Direction) {
        guard exitOne.isAdjacentTo(exitTwo) else {
            return nil
        }
        self.exitOne = exitOne
        self.exitTwo = exitTwo
    }

    func bendDirection(direction: Direction?) -> Direction? {
        if direction?.toggle() == exitOne {
            return exitTwo            
        }
        if direction?.toggle() == exitTwo {
            return exitOne
        }
        return nil
    }
}
