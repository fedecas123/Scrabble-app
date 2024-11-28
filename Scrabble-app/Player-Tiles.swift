//
//  PlayerTiles.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import SwiftUI

struct PlayerTiles: View {
    
    @Binding var player: Player
    
    @Binding var isPlayerOneTurn: Bool
    let tileSpacing: CGFloat
    let tileWidth: CGFloat
    let isPlayerOne: Bool
    @Binding var playerUsedTiles: [String: Int]

    var body: some View {
        ZStack {Color("grey1")
            VStack (spacing: 30) {
                
                HStack {
                    ZStack {
                        
                        Text("P\(isPlayerOne ? "1" : "2")")
                            .foregroundStyle(Color.black)
                            .font(.title)
                            .padding(8)
                            .background(Color("grey2"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    
                    Spacer()
                    
                    Text("SCORE: \(player.score)")
                        .foregroundStyle(Color.black)
                        .font(.title)
                }
                .padding(.horizontal, 12)
                
                
                HStack (spacing: tileSpacing) {
                    
                    ForEach(0..<player.tiles.count, id: \.self) { index in
                        
                        let tile = player.tiles[index].capitalized
                                                
                        // Count how many times this tile has been used
                        let usedCount = playerUsedTiles[tile, default: 0]
                        
                        // Calculate how many times this tile appears in the player's hand
                        let totalCount = player.tiles.filter { $0.capitalized == tile }.count
                        
                        // If the tile has been used as many times as it appears, reduce opacity
                        let opacity = usedCount >= totalCount ? 0.5 : 1.0
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("letterPresentTile"))
                                .frame(width: tileWidth + tileSpacing, height: tileWidth + tileSpacing)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("letterPresentTileOutline"), lineWidth: 2)
                                    )
                                                                
                            Text("\(player.tiles[index].capitalized)")
                                .foregroundColor(Color.black)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("\(letterPoints[player.tiles[index].capitalized]!)")
                                .foregroundColor(Color.black)
                                .font(.caption)
                                .fontWeight(.regular)
                                .offset(x: tileWidth / 2.7, y: tileWidth / 2.7)
                        }
                        .opacity(opacity)

                    }
                    // for each
                }
                .padding(.horizontal, 20)
                // tiles h
        
            }
            // main v
        }
        .frame(width: 500, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        // main z
        
        
        
    }
}


