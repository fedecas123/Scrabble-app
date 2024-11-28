//
//  Scrabble.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

// opacity used letters
// fix bug when using already used tile

import SwiftUI

struct Player {
    var tiles: [String]
    var score: Int
}

struct Scrabble: View {
    
    @State var board: [[String]] = reset_board()
    
    @State var backupBoard: [[String]] = reset_board()
    
    @State var availableLetterCounts: [String: Int] = resetLetterCounts()
    
    @State var playerOne: Player = Player(tiles: [], score: 0)
                                                  
    @State var playerTwo: Player = Player(tiles: [], score: 0)
    
    @State var playerOneUsedTiles: [String: Int] = [:]
    @State var playerTwoUsedTiles: [String: Int] = [:]
    
    @State var isPlayerOneTurn: Bool = true
    
    @State var isGameStarted: Bool = false
    
    @State var wordsPlaced: Int = 0
    
    @State var totalRemainingLettersNumber: Int = 100
    
    @State var isShuffleAlhpaHovering: Bool = false
    @State var isShufflePointsHovering: Bool = false
    @State var isShuffleRandomHovering: Bool = false
    @State var isRedrawHovering: Bool = false
    
    @State var wordsFormed: [String] = []
    
    @State var cpuPlayerWord: [Any] = []
    
    @State var showCpuWord: Bool = false
    
    let tileSpacing: CGFloat = 8
    let tileWidth: CGFloat = 40
    
    var body: some View {
        ZStack { Color("boardBackground")
            VStack (spacing: 48) {
                
                Spacer()
                
                ScrabbleTitle()
               
                
                HStack (spacing: 40) {
                    Spacer()
                    
                    AvailableLetterCounts(availableLetterCounts: $availableLetterCounts, totalRemainingLettersNumber: $totalRemainingLettersNumber)
                    
                    Board(board: $board, backupBoard: $backupBoard, playerOne: $playerOne, playerTwo: $playerTwo, isPlayerOneTurn: $isPlayerOneTurn, tileSpacing: tileSpacing, tileWidth: tileWidth, playerOneUsedTiles: $playerOneUsedTiles, playerTwoUsedTiles: $playerTwoUsedTiles, isGameStarted: $isGameStarted)
                    
                    VStack (spacing: 50) {
                        
                        
                        if showCpuWord {
                            Text("\(cpuPlayerWord.count > 0 ? cpuPlayerWord.description : "Could not find a word")")
                                .foregroundStyle(.black)
                                .font(.title)
                                .onTapGesture {
                                    showCpuWord.toggle()
                                }
                                .offset(y: 25)
                                .animation(.spring, value: showCpuWord)
                        } else {
                            Text("CPU Word Hidden")
                                .foregroundStyle(.black)
                                .font(.title)
                                .onTapGesture {
                                    showCpuWord.toggle()
                                }
                                .offset(y: 25)
                                .animation(.spring, value: showCpuWord)
                            
                        }
                        
                        Text("\(wordsFormed.isEmpty ? "" : "Last Word: ") \(wordsFormed.joined(separator: ", "))")
                            .font(.body)
                            .foregroundStyle(Color.black)
                        
                        
                        HStack (spacing: 20) {
                            
                            Button {
                                if isPlayerOneTurn {
                                    withAnimation (.spring(duration: 0.4)) {
                                        let result =  changeTiles(availableLetterCounts: availableLetterCounts, playerTiles: playerOne.tiles)
                                        
                                        availableLetterCounts = result[0] as! [String : Int]
                                        playerOne.tiles = result[1] as! [String]
                                    }
                                    isPlayerOneTurn.toggle()
                                    
                                } else {
                                    withAnimation (.spring(duration: 0.4)) {
                                        let result =  changeTiles(availableLetterCounts: availableLetterCounts, playerTiles: playerTwo.tiles)
                                        
                                        availableLetterCounts = result[0] as! [String : Int]
                                        playerTwo.tiles = result[1] as! [String]
                                    }
                                    isPlayerOneTurn.toggle()
                                }
                                
                                if isPlayerOneTurn {
                                    cpuPlayerWord = findCPUMoves(board: backupBoard, cpuLetters: playerOne.tiles, wordsPlaced: wordsPlaced)
                                } else {
                                    cpuPlayerWord = findCPUMoves(board: backupBoard, cpuLetters: playerTwo.tiles, wordsPlaced: wordsPlaced)
                                }
                                
                            } label: {
                                Text("Redraw Tiles")
                                    .frame(height: 55)
                                    .padding(.horizontal, 16)
                                    .background(Color("noMultTile"))
                                    .foregroundStyle(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: isRedrawHovering ? 2 : 0.75)
                                            .fill(Color("centerTile"))
                                    }
                            }
                            .onHover { ishovering in
                                if ishovering {
                                    isRedrawHovering = true
                                } else {
                                    isRedrawHovering = false
                                }
                            }
                            .buttonStyle(.borderless)
                            .disabled(!isGameStarted)
                            
                            Rectangle()
                                .foregroundStyle(Color("noMultTile"))
                                .frame(width: 1, height:55)
                            
                            Text("Shuffle Options:")
                                .foregroundStyle(Color.black)
                                
                            Button {
                                if isPlayerOneTurn {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerOne.tiles = shuffle_tiles(tiles: playerOne.tiles, mode: "alphabetically")
                                    }

                                } else {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerTwo.tiles = shuffle_tiles(tiles: playerTwo.tiles, mode: "alphabetically")
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "character")
                                    .frame(width: 55, height: 55)
                                    .background(Color("noMultTile"))
                                    .foregroundStyle(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: isShuffleAlhpaHovering ? 2 : 0.75)
                                            .fill(Color("centerTile"))
                                    }
                            }
                            .buttonStyle(.borderless)
                            .onHover { ishovering in
                                if ishovering {
                                    isShuffleAlhpaHovering = true
                                } else {
                                    isShuffleAlhpaHovering = false
                                }
                            }
                            
                            Button {
                                if isPlayerOneTurn {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerOne.tiles = shuffle_tiles(tiles: playerOne.tiles, mode: "random")
                                    }

                                } else {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerTwo.tiles = shuffle_tiles(tiles: playerTwo.tiles, mode: "random")
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .frame(width: 55, height: 55)
                                    .background(Color("noMultTile"))
                                    .foregroundStyle(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: isShuffleRandomHovering ? 2 : 0.75)
                                            .fill(Color("centerTile"))
                                    }
                            }
                            .buttonStyle(.borderless)
                            .onHover { ishovering in
                                if ishovering {
                                    isShuffleRandomHovering = true
                                } else {
                                    isShuffleRandomHovering = false
                                }
                            }
                            
                            Button {
                                if isPlayerOneTurn {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerOne.tiles = shuffle_tiles(tiles: playerOne.tiles, mode: "bypoints")
                                    }

                                } else {
                                    withAnimation (.spring(duration: 0.4)) {
                                        playerTwo.tiles = shuffle_tiles(tiles: playerTwo.tiles, mode: "bypoints")
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "numbersign")
                                    .frame(width: 55, height: 55)
                                    .background(Color("noMultTile"))
                                    .foregroundStyle(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: isShufflePointsHovering ? 2 : 0.75)
                                            .fill(Color("centerTile"))
                                    }
                            }
                            .buttonStyle(.borderless)
                            .onHover { ishovering in
                                if ishovering {
                                    isShufflePointsHovering = true
                                } else {
                                    isShufflePointsHovering = false
                                }
                            }

                        }
                        .disabled(!isGameStarted)
                        // h shuffles
                        
                        
                        PlayerTiles(player: $playerOne, isPlayerOneTurn: $isPlayerOneTurn, tileSpacing: tileSpacing, tileWidth: tileWidth, isPlayerOne: true, playerUsedTiles: $playerOneUsedTiles)
                            .overlay {
                                if isPlayerOneTurn{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(Color("centerTile"))
                                }
                            }
                        
                        PlayerTiles(player: $playerTwo, isPlayerOneTurn: $isPlayerOneTurn, tileSpacing: tileSpacing, tileWidth: tileWidth, isPlayerOne: false, playerUsedTiles: $playerTwoUsedTiles)
                            .overlay {
                                if !isPlayerOneTurn {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(Color("centerTile"))
                                }
                            }
                        
                        HStack (spacing: 50) {
                            StartResetButton(board: $board, backupBoard: $backupBoard, isGameStarted: $isGameStarted, playerOne: $playerOne, playerTwo: $playerTwo, availableLetterCounts: $availableLetterCounts, totalRemainingLettersNumber: $totalRemainingLettersNumber, isPlayerOneTurn: $isPlayerOneTurn, wordsFormed: $wordsFormed, cpuPlayerWord: $cpuPlayerWord, wordsPlaced: $wordsPlaced)
                                .onTapGesture {
                                    wordsFormed = []
                                }
                            
                            if isGameStarted {
                                
                                Button {
                                    
                                    let result = is_new_board_valid(board: board, backupBoard: backupBoard, wordsPlaced: wordsPlaced)
                                                                        
                                    if result[0] as! Bool {
                                        backupBoard = board
                                        isPlayerOneTurn.toggle()
                                        wordsPlaced += 1
                                        wordsFormed = result[2] as! [String]
                                        
                                        if isPlayerOneTurn {
                                            
                                            let arrayFromDict = playerTwoUsedTiles.flatMap { (letter, count) -> [String] in
                                                Array(repeating: letter, count: count)
                                            }

                                            var tempPlayerTiles = playerTwo.tiles
                                            
                                            for used_letter in arrayFromDict {
                                                let normalizedLetter = used_letter.uppercased()
                                                
                                                if let index = tempPlayerTiles.firstIndex(where: { $0.uppercased() == normalizedLetter }) {
                                                    tempPlayerTiles.remove(at: index)
                                                }
                                            }
                                            
                                            let (updatedLetterCounts, playerNewLetters) = getLettersFromBag(availableLetterCounts: availableLetterCounts, playerLetters: tempPlayerTiles.count)

                                            availableLetterCounts = updatedLetterCounts
                                            tempPlayerTiles.append(contentsOf: playerNewLetters)
                                            
                                            withAnimation {
                                                playerTwo.tiles = tempPlayerTiles
                                                totalRemainingLettersNumber = totalLettersRemaining(availableLetterCounts)
                                            }
                                            
                                            playerTwo.score += result[1] as! Int
                                            playerTwoUsedTiles = [:]
                                            
                                        } else {

                                            let arrayFromDict = playerOneUsedTiles.flatMap { (letter, count) -> [String] in
                                                Array(repeating: letter, count: count)
                                            }

                                            var tempPlayerTiles = playerOne.tiles
                                            
                                            for used_letter in arrayFromDict {
                                                let normalizedLetter = used_letter.uppercased()
                                                
                                                if let index = tempPlayerTiles.firstIndex(where: { $0.uppercased() == normalizedLetter }) {
                                                    tempPlayerTiles.remove(at: index)
                                                }
                                            }
                                            
                                            let (updatedLetterCounts, playerNewLetters) = getLettersFromBag(availableLetterCounts: availableLetterCounts, playerLetters: tempPlayerTiles.count)

                                            availableLetterCounts = updatedLetterCounts
                                            tempPlayerTiles.append(contentsOf: playerNewLetters)
                                            
                                            withAnimation {
                                                playerOne.tiles = tempPlayerTiles
                                                totalRemainingLettersNumber = totalLettersRemaining(availableLetterCounts)
                                            }
                                                
                                            playerOne.score += result[1] as! Int
                                            playerOneUsedTiles = [:]

                                        }
                                        
                                        // get best cpu player word
                                        
                                        if isPlayerOneTurn {
                                            cpuPlayerWord = findCPUMoves(board: backupBoard, cpuLetters: playerOne.tiles, wordsPlaced: wordsPlaced)
                                        } else {
                                            cpuPlayerWord = findCPUMoves(board: backupBoard, cpuLetters: playerTwo.tiles, wordsPlaced: wordsPlaced)
                                        }
                                        
                                        
                                        

                                    }
          
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color("doubleLetterTile"))
                                            .frame(width: 220, height: 70)
                                            .opacity(false ? 0.7 : 1)
                                        
                                        Text("VALIDATE BOARD")
                                            .foregroundStyle(Color.white)
                                            .font(.body)
                                            .fontWeight(.bold)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                // button

                            }
                        }
                        
                    }
                    Spacer()
                }
                // main h
                
                Spacer()
            }
            // main v
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        //.padding(.horizontal, 50)

        // main z
    }
    
    func totalLettersRemaining(_ letterPoints: [String: Int]) -> Int {
        return letterPoints.values.reduce(0, +)
    }

}


#Preview {
    Scrabble()
}
