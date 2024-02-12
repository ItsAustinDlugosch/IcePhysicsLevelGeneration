enum ActivationContext {
    // How a tiles are interacted with by LevelMovableobjects
    // Start On -> Start Adjacent -> Slide Into
    // Slide On -> Slide Adjcaent -> Slide Into
    // Stop On -> Stop Adjacent
    case startOn, stopOn   
    case startAdjacent(_ direction: Direction), slideAdjacent(_ direction: Direction), stopAdjacent(_ direction:Direction)
    case slideInto, slideOn
}
