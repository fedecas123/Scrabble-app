//
//  Start-Reset-Button.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 19/10/24.
//

import SwiftUI

struct StartResetButton: View {
    
    
    @Binding var board: [[String]]
    @Binding var backupBoard: [[String]]
    @Binding var isGameStarted: Bool
    @Binding var playerOne: Player 
    @Binding var playerTwo: Player
    @Binding var availableLetterCounts: [String: Int]
    @Binding var totalRemainingLettersNumber: Int
    @Binding var isPlayerOneTurn: Bool
    @Binding var wordsFormed: [String]
    @Binding var cpuPlayerWord: [Any]
    @Binding var wordsPlaced: Int
    
    @State var isHoveringReset: Bool = false

    
    var body: some View {
        
        Button {
            withAnimation (.easeOut(duration: 0.3)) {
                    let newBoard = reset_board()
                    board = newBoard
                    backupBoard = newBoard
                    availableLetterCounts = resetLetterCounts()
                    isPlayerOneTurn = true
                    wordsPlaced = 0
                    cpuPlayerWord = []
                    playerOne.score = 0
                    playerTwo.score = 0
                    
                
                    print("reset")
                }
            
            isGameStarted.toggle()
            
            if isGameStarted {
                let (updatedLetterCounts, playerOneNewLetters) = getLettersFromBag(availableLetterCounts: availableLetterCounts, playerLetters: 0)
                let (newUpdatedLetterCounts, playerTwoNewLetters) = getLettersFromBag(availableLetterCounts: updatedLetterCounts, playerLetters: 0)
    
                availableLetterCounts = newUpdatedLetterCounts
                playerOne.tiles = playerOneNewLetters
                playerTwo.tiles = playerTwoNewLetters
                
                totalRemainingLettersNumber = totalLettersRemaining(availableLetterCounts)
                
                wordsFormed = []
                
                cpuPlayerWord = findCPUMoves(board: backupBoard, cpuLetters: playerOne.tiles, wordsPlaced: wordsPlaced)
                
                print("done")

            } else {
                playerOne.tiles = []
                playerTwo.tiles = []
                totalRemainingLettersNumber = 100
            }
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isGameStarted ?  Color("centerTile") : Color("scrabbleTitle"))
                    .frame(width: 220, height: 70)
                    .opacity(isHoveringReset ? 0.7 : 1)
                
                Text("\(isGameStarted ? "RESET GAME" : "START GAME")")
                    .foregroundStyle(Color.white)
                    .font(.body)
                    .fontWeight(.bold)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeIn(duration: 0.1)) {
                isHoveringReset = hovering
            }
        }

    }
    
    func totalLettersRemaining(_ letterPoints: [String: Int]) -> Int {
        return letterPoints.values.reduce(0, +)
    }
}
