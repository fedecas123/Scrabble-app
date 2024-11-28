//
//  Available-Letter-Counts.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//
import SwiftUI

struct AvailableLetterCounts: View {
    
    @Binding var availableLetterCounts: [String: Int]
    @Binding var totalRemainingLettersNumber: Int
    
    
    var groupedLetters: [[(String, Int)]] {
        let lettersArray = Array(availableLetterCounts).sorted { $0.key < $1.key }
        return stride(from: 0, to: lettersArray.count, by: 5).map {
            Array(lettersArray[$0..<min($0 + 5, lettersArray.count)])
        }
    }

    var body: some View {
        ZStack {Color("grey1")
            VStack (spacing: 12) {
                Text("Letters remaining: \(totalRemainingLettersNumber)")
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .padding(8)
                    .background(Color("grey2"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                ForEach(Array(groupedLetters.enumerated()), id: \.0) { index, row in
                    HStack (spacing: 8){
                        ForEach(row, id: \.0) { letter, count in // Use the letter (String) as the id
                            VStack {
                                Text(letter)
                                    .font(.headline)
                                Text("\(count)")
                                    .font(.subheadline)
                            }
                            .frame(width: 40, height: 60, alignment: .center)
                            .background(Color("grey2"))
                            .foregroundStyle(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(width: 260, height: .leastNonzeroMagnitude)
    }
}

#Preview {
    Scrabble()
}
