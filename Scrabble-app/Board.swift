//
//  Board.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import SwiftUI

struct Board: View {
    
    @Binding var board: [[String]]
    @Binding var backupBoard: [[String]]
    @Binding var playerOne: Player
    @Binding var playerTwo: Player
    @Binding var isPlayerOneTurn: Bool
    
    let tileSpacing: CGFloat
    let tileWidth: CGFloat
    
    @Binding var playerOneUsedTiles: [String: Int]
    @Binding var playerTwoUsedTiles: [String: Int]
    @Binding var isGameStarted: Bool
    
    var body: some View {
        ZStack {
            VStack {
                VStack (spacing: tileSpacing) {
                    ForEach(0..<15, id: \.self) { row in
                        HStack (spacing: tileSpacing) {
                          
                            Text("\(row) ")
                                .foregroundStyle(Color("centerTile"))
                                .font(.caption)
                                .frame(width:15)
                            
                            ForEach(0..<15, id: \.self) { column in
                                VStack {
                                    if row == 0 {
                                        Text("\(column)")
                                            .foregroundStyle(Color("centerTile"))
                                            .font(.caption)
                                            .frame(width:15)
                                        
                                    }
                                    
                                    BoardTile(board: $board, backupBoard: $backupBoard, playerOne: $playerOne, playerTwo: $playerTwo, isPlayerOneTurn: $isPlayerOneTurn, i: row, j: column, tileSpacing: tileSpacing, tileWidth: tileWidth, playerOneUsedTiles: $playerOneUsedTiles, playerTwoUsedTiles: $playerTwoUsedTiles, isGameStarted: $isGameStarted)
                                }
                                
                            }
                        }
                    }
                }
                // board

            }
            // main v
        }
        // main z
    }
}

#Preview {
    Scrabble()
}


