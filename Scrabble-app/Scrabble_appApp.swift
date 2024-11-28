//
//  Scrabble_appApp.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import SwiftUI
import PythonKit

@main
struct Scrabble_appApp: App {
    @StateObject var nav = NavigationManager()
    
    init() {
//            PythonLibrary.useLibrary(at: "/usr/local/bin/python3")
            PythonLibrary.useLibrary(at: "/opt/anaconda3/bin/python3")
        }
    
    var body: some Scene {
        WindowGroup {
            if !nav.showScrabble {
                PromptForPathView(nav: nav)
            } else {
                Scrabble()
            }
        }
    }
        
}


