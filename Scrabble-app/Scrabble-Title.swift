//
//  Scrabble-Title.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import SwiftUI

struct ScrabbleTitle: View {
    
    let title = ["S", "C", "R", "A", "B", "B", "L", "E"]
    
    var body: some View {
        HStack {
            ForEach(0..<8, id: \.self) { letter in
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("scrabbleTitle"))
                        .frame(width: 55, height: 55)
                    Text("\(title[letter])")
                        .foregroundColor(Color.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
            }
            // for each letter
        }
        // main h
    }
}

#Preview {
    ScrabbleTitle()
        .padding(50)
}
