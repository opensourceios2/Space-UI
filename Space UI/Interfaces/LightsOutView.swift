//
//  LightsOutView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-09-05.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct LightsOutView: View {
    
    static let buttonLength: CGFloat = 100.0
    
    let boardLength = 3
    
    @State var puzzleBoard: [[Bool]] = {
        var board = [[Bool]]()
        for _ in 0..<3 {
            board.append([Bool.random(), Bool.random(), Bool.random()])
        }
        return board
    }()
    
    var body: some View {
        ZStack {
            GridShape(rows: boardLength, columns: boardLength, outsideCornerRadius: system.cornerRadius(forLength: SudokuView.buttonLength))
                .stroke(Color(color: .primary, opacity: .max), lineWidth: system.thinLineWidth)
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {
                    makeButton(coord: GridCoord(row: 0, column: 0))
                    makeButton(coord: GridCoord(row: 0, column: 1))
                    makeButton(coord: GridCoord(row: 0, column: 2))
                }
                GridRow {
                    makeButton(coord: GridCoord(row: 1, column: 0))
                    makeButton(coord: GridCoord(row: 1, column: 1))
                    makeButton(coord: GridCoord(row: 1, column: 2))
                }
                GridRow {
                    makeButton(coord: GridCoord(row: 2, column: 0))
                    makeButton(coord: GridCoord(row: 2, column: 1))
                    makeButton(coord: GridCoord(row: 2, column: 2))
                }
            }
            .clipShape(GridShape(rows: boardLength, columns: boardLength, outsideCornerRadius: system.cornerRadius(forLength: SudokuView.buttonLength)))
        }
        .frame(width: SudokuView.buttonLength * CGFloat(boardLength), height: SudokuView.buttonLength * CGFloat(boardLength), alignment: .center)
    }
    
    func makeButton(coord: GridCoord) -> some View {
        let cellContent = puzzleBoard[coord.row][coord.column]
        
        return Button(action: {
            self.selectCell(coord: coord)
        }) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                if cellContent {
                    Text("ON")
                }
            }
        }
        .font(Font.spaceFont(size: 40))
        .frame(width: SudokuView.buttonLength, height: SudokuView.buttonLength, alignment: .center)
    }
    
    func selectCell(coord: GridCoord) {
        puzzleBoard[coord.row][coord.column].toggle()
        if 0 <= coord.row-1 {
            puzzleBoard[coord.row-1][coord.column].toggle()
        }
        if 0 <= coord.column-1 {
            puzzleBoard[coord.row][coord.column-1].toggle()
        }
        if coord.row+1 < boardLength {
            puzzleBoard[coord.row+1][coord.column].toggle()
        }
        if coord.column+1 < boardLength {
            puzzleBoard[coord.row][coord.column+1].toggle()
        }
        checkSuccess()
    }
    
    func checkSuccess() {
        if puzzleBoard.allSatisfy({ !$0.contains(false) }) {
            PeerSessionController.shared.send(message: .emergencyEnded)
            ShipData.shared.endEmergency()
        }
    }
    
}

struct LightsOutView_Previews: PreviewProvider {
    static var previews: some View {
        LightsOutView()
    }
}
