//
//  Board2.swift
//  ReducerTutorial
//
//  Created by windowcow on 2/11/25.
//

import ComposableArchitecture

@Reducer
struct Board {
    @ObservableState
    struct State {
        var cells: [[Cell]] = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
        var currentPlayer: Player = .o
        
        var showOccupiedAlert: Bool = false

        var occupiedCellCount: Int {
            cells.flatMap { $0 }
                 .filter { $0 != .empty }
                 .count
        }
        
    }
    
    @ObservableState
    @CasePathable
    enum Cell {
        case empty
        case filled(Player)
    }
    
    enum Action: ViewAction {
        // MARK: - View
        case view(View) // -> evaluate

        @CasePathable
        enum View: ViewAction {
            case tap(Int, Int)
        }
        
        case setOwner(Player, Int, Int) // nextTurn, Delegate
        case alreadyOccupied
        case resetOccupiedAlert // 애니메이션 상태 리셋

        case evaluate // -> setOwner
        case nextTurn
        
        case newGame
        case clear
        
        case delegate(Delegate)
        
        
        @CasePathable
        enum Delegate {
            case hasWinner(Player)
            case draw
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.tap(let row, let col)):
                return .send(.setOwner(state.currentPlayer, row, col))
                
            case .setOwner(let owner, let row, let col):
                guard state.cells[row][col] == .empty else {
                    return .send(.alreadyOccupied)
                }
                
                state.cells[row][col] = .filled(owner)
                
                return .send(.evaluate)
            case .alreadyOccupied:
                state.showOccupiedAlert = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 500 * 1_000_000) // 0.5초 대기
                    await send(.resetOccupiedAlert)
                }
            case .resetOccupiedAlert:
                state.showOccupiedAlert = false
                return .none
            case .evaluate:
                if let winner = checkWinner(board: state.cells) {
                    return .send(.delegate(.hasWinner(winner)))
                }
                
                if state.occupiedCellCount == 9 {
                    return .send(.delegate(.draw))
                }
                
                return .send(.nextTurn)
                
            case .nextTurn:
                state.currentPlayer = state.currentPlayer.nextPlayer()
                return .none
                
            case .newGame:
                return .send(.clear)
                
            case .clear:
                state.cells = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
                state.currentPlayer = .o
                return .none
            default:
                return .none
            }
        }
        ._printChanges()
    }
    
    private func checkWinner(board: [[Cell]]) -> Player? {
        for row in 0..<3 {
            if case let .filled(player) = board[row][0],
               board[row][1] == .filled(player),
               board[row][2] == .filled(player) {
                return player
            }
        }

        for col in 0..<3 {
            if case let .filled(player) = board[0][col],
               board[1][col] == .filled(player),
               board[2][col] == .filled(player) {
                return player
            }
        }

        if case let .filled(player) = board[0][0],
           board[1][1] == .filled(player),
           board[2][2] == .filled(player) {
            return player
        }

        if case let .filled(player) = board[0][2],
           board[1][1] == .filled(player),
           board[2][0] == .filled(player) {
            return player
        }
        return nil
    }
}

extension Board: Equatable {}
extension Board.State: Equatable {}
extension Board.Cell: Equatable {}








