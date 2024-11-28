//
//  PromptForPathView.swift
//  Scrabble-app
//
//  Created by Federica Caselli on 28/11/24.
//

import SwiftUI

struct PromptForPathView: View {
    @ObservedObject var nav: NavigationManager
    @State var path: String = ""
    @State var continuePressed: Bool = false
    @State var error: String?
    
    var body: some View {
        VStack {
            Text("Please enter the (absolute) path to the scrabble file (Scrabble-app-main):")
                .font(.headline)
                .padding(.top)
            
            TextField("", text: $path)
                .padding()
                .foregroundStyle(.black)
                .background(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
            
            if (error != nil) {
                Text(error ?? "")
                    .font(.headline)
                    .foregroundStyle(.red)
            }
            
            Button {
                continuePressed.toggle()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue.opacity(0.8)))
                    .shadow(radius: 3, x: 3, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            
        }
        .onChange(of: continuePressed) { _, newValue in
            if !path.isEmpty && newValue {
                if !path.hasSuffix("/Scrabble-app-main") {
                    error = "Please enter the path to the Scrabble file (Scrabble-app-main)"
                } else {
                    setPathToPythonFiles(path: path)
                    nav.showScrabble = true
                }
            }
        }
        
    }
}

#Preview {
    PromptForPathView(nav: NavigationManager())
}
