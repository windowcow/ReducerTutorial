import ComposableArchitecture

struct InitialCellsBuilder {
    static func build(rows: Int = 3, cols: Int = 3) -> IdentifiedArrayOf<Cell.State> {
        var array = IdentifiedArrayOf<Cell.State>()
        
        for row in 0..<rows {
            for col in 0..<cols {
                let cellState = Cell.State(row: row, col: col)
                array.append(cellState)
            }
        }
        
        return array
    }
}
