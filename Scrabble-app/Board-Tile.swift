//
//  BoardTile.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import SwiftUI

struct BoardTile: View {
    
    @Binding var board: [[String]]
    @Binding var backupBoard: [[String]]
    @Binding var playerOne: Player
    @Binding var playerTwo: Player
    @Binding var isPlayerOneTurn: Bool
    let i: Int
    let j: Int
    let tileSpacing: CGFloat
    let tileWidth: CGFloat
    @Binding var playerOneUsedTiles: [String: Int]
    @Binding var playerTwoUsedTiles: [String: Int]
    @Binding var isGameStarted: Bool
    
    @State private var isHovering: Bool  = false
    @State private var input: String = ""
    @FocusState private var focusInput: Bool
    @State private var isInput: Bool = false
    @State private var previousInput: String = ""
    @State private var isDisabled: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(tileColor(for: board[i][j]))
                .frame(width: tileWidth, height: tileWidth)
                .opacity(isHovering ? 0.6 : 1)
            Text("\(isHovering ? "" : tileText(for: board[i][j]))")
                .foregroundColor(Color.white)
                .font(.body)
                .fontWeight(.regular)
                .overlay { // overlay to extend the tile
                    if (Int(board[i][j]) == nil) {
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(tileColor(for: board[i][j]))
                            .frame(width: tileWidth + tileSpacing, height: tileWidth + tileSpacing)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4) // centerTile
                                    .stroke(isInput ? Color("centerTile") : Color("letterPresentTileOutline"), lineWidth: 2)
                                )
                        
                        ZStack {
                            
                            Text("\(board[i][j].capitalized)")
                                .foregroundColor(Color.black)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("\(letterPoints[board[i][j].capitalized]!)") // crash
                                .foregroundColor(Color.black)
                                .font(.caption)
                                .fontWeight(.regular)
                                .offset(x: tileWidth / 2.7, y: tileWidth / 2.7)
                        }
                    }
                }
                // overlay
            
            if isHovering {
                TextField("", text: $input)
                    .focused($focusInput)
                    .foregroundStyle(Color.black)
                    .frame(width: tileWidth-10, height: tileWidth-10)
                    .onChange(of: input) { _, newValue in
                        if newValue.count > 1 {
                            input = String(newValue.prefix(1))
                        }
                        
                        if !isValidInput(newValue) {
                            input = ""
                            board[i][j] = backupBoard[i][j]
                        }
                    }
            }
           
        }
        .onHover { hovering in
            isHovering = hovering
            if !(Int(board[i][j]) == nil && board[i][j].count > 1) {
                focusInput = hovering
            }
            
            if input.count > 0 {
                board[i][j] = input.capitalized
                isInput = true
            } else {
                board[i][j] = backupBoard[i][j]
            }
        }
        .onChange(of: isGameStarted) { _, newValue in
            input = ""
            isInput = false
            if newValue == false {
                isDisabled = true
            } else {
                isDisabled = false
            }
            
        }
        .onChange(of: isPlayerOneTurn) { _, _ in
            isInput = false
            if input.count > 0 {
                isDisabled = true
            }
        }
        .onChange(of: input) { oldValue, newValue in
            if newValue.isEmpty {
                if !previousInput.isEmpty {
                    let previousLetter = previousInput.capitalized

                    if isPlayerOneTurn {
                        if let currentValue = playerOneUsedTiles[previousLetter], currentValue > 0 {
                            playerOneUsedTiles[previousLetter] = currentValue - 1
                        }
                    } else {
                        if let currentValue = playerTwoUsedTiles[previousLetter], currentValue > 0 {
                            playerTwoUsedTiles[previousLetter] = currentValue - 1
                        }
                    }
                }

                previousInput = ""
            } else {
                previousInput = newValue.capitalized
            }
        }
        .disabled(isDisabled)
        // main z
    }



    func isValidInput(_ value: String) -> Bool {
        let inputLetter = value.capitalized

        guard inputLetter.count == 1, inputLetter.range(of: "[A-Z]", options: .regularExpression) != nil else {
            return false
        }

        if isPlayerOneTurn {
            let availableTileCount = playerOne.tiles.filter { $0 == inputLetter }.count
            let usedTileCount = playerOneUsedTiles[inputLetter] ?? 0
            
            if availableTileCount > usedTileCount {
                playerOneUsedTiles[inputLetter, default: 0] += 1
                return true
            }
        } else {
            let availableTileCount = playerTwo.tiles.filter { $0 == inputLetter }.count
            let usedTileCount = playerTwoUsedTiles[inputLetter] ?? 0
            
            if availableTileCount > usedTileCount {
                playerTwoUsedTiles[inputLetter, default: 0] += 1
                return true
            }
        }
        return false
    }





    func tileColor(for value: String) -> Color {
        switch value {
        case "0":
            return Color("noMultTile")
        case "1":
            return Color("centerTile")
        case "2":
            return Color("doubleLetterTile")
        case "3":
            return Color("tripleLetterTile")
        case "4":
            return Color("doubleWordTile")
        case "5":
            return Color("tripleWordTile")
        default:
            return Color("letterPresentTile")
        }
    }
    
    func tileText(for value: String) -> String {
        switch value {
        case "0":
            return ""
        case "1":
            return "" // center
        case "2":
            return "DL"
        case "3":
            return "TL"
        case "4":
            return "DW"
        case "5":
            return "TW"
        default:
            return self.board[i][j]
        }
    }
}

//#Preview {
//    VStack (spacing: 20) {
//        BoardTile(value: "0", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "1", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "2", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "3", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "4", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "5", tileSpacing: 8, tileWidth: 40)
//        BoardTile(value: "E1", tileSpacing: 8, tileWidth: 40)
//    }
//    .padding(50)
//}
