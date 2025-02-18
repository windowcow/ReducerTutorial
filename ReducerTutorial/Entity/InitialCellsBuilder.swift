import ComposableArchitecture

struct InitialCellsBuilder {
    static func build(size: Int = 3) -> IdentifiedArrayOf<Cell.State> {
        var array = IdentifiedArrayOf<Cell.State>()
        
        for row in 0..<size {
            for col in 0..<size {
                let cellState = Cell.State(row: row, col: col)
                array.append(cellState)
            }
        }
        
        return array
    }
}
