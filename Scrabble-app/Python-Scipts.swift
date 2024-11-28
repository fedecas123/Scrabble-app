//
//  PythonScipts.swift
//  Scrabble-app
//
//  Created by Georgios Klonis on 15/10/24.
//

import Foundation
import PythonKit


class NavigationManager: ObservableObject {
    @Published var showScrabble: Bool = false
}

//var pathToPythonFiles = "/Users/fc/Documents/AAASEMESTERIII/ALGORITHM/FinalProject/Scrabble-app/Scrabble-app/Scrabble"
var pathToPythonFiles: String = ""
//let pathToPythonFiles = FileManager.default.currentDirectoryPath.appending("../Scrabble")

func setPathToPythonFiles(path: String) {
    pathToPythonFiles = path
    pathToPythonFiles.append("/Scrabble-app/Scrabble")
}

func reset_board() -> [[String]] {
    
    let pathToPythonFile = pathToPythonFiles // path to python flie, without / in the end, do not include python file itself only until final drectory
    
    let pythonFile = "reset_board" // python file without .py
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile) // Append path to sys.path
    let file = Python.import(pythonFile) // Import the Python file/module
    
    let response = file.reset_board() // Call the Python function
    
    var arr: [[String]] = []

    for row in response {
        var newRow: [String] = []
        for cell in row {
            if let cellValue = String(cell) {
                newRow.append(cellValue)
            }
        }
        arr.append(newRow)
    }
    return arr
}

func resetLetterCounts() -> [String: Int] {
    let pathToPythonFile = pathToPythonFiles
    let pythonFile = "reset_letter_count_in_bag"
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)
    
    let file = Python.import(pythonFile)
    let response = file.reset_letter_count_in_bag()
    
    var letterCountDict: [String: Int] = [:]
    
    for key in response.keys() {
        if let letter = String(key), let count = Int(response[key]) {
            letterCountDict[letter] = count
        }
    }
    
    return letterCountDict
}

func getLettersFromBag(availableLetterCounts: [String: Int], playerLetters: Int) -> ([String: Int], [String]) {
    

    let pathToPythonFile = pathToPythonFiles
    let pythonFile = "get_letters_from_bag"
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)

    
    let file = Python.import(pythonFile)
    let response = file.get_letters_from_bag(availableLetterCounts, playerLetters)
    
    var updatedLetterCounts: [String: Int] = [:]
    var newLetters: [String] = []
    
    let letterCountsResponse = response[0]
    for key in letterCountsResponse.keys() {
        if let letter = String(key), let count = Int(letterCountsResponse[key]) {
            updatedLetterCounts[letter] = count
        }
    }
    
    let newLettersResponse = response[1]
    for letter in newLettersResponse {
        if let letterStr = String(letter) {
            newLetters.append(letterStr)
        }
    }
    
    return (updatedLetterCounts, newLetters)
}


//func is_new_board_valid(board: [[String]], backupBoard: [[String]], wordsPlaced: Int) -> [Any] {
//    let pathToPythonFile = pathToPythonFiles
//    let pythonFile = "is_new_board_valid"
//    
//    let sys = Python.import("sys")
//    sys.path.append(pathToPythonFile)
//    
//    let file = Python.import(pythonFile)
//    
//    let boardPy = PythonObject(board)
//    let backupBoardPy = PythonObject(backupBoard)
//    
//    let response = file.is_new_board_valid(boardPy, backupBoardPy, wordsPlaced)
//    let isValid = Bool(response[0]) ?? false
//    let score = Int(response[1]) ?? 0
//    
//    return [isValid, score]
//}

func is_new_board_valid(board: [[String]], backupBoard: [[String]], wordsPlaced: Int) -> [Any] {
    let pathToPythonFile = pathToPythonFiles
    let pythonFile = "is_new_board_valid"
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)
    
    let file = Python.import(pythonFile)
    
    let boardPy = PythonObject(board)
    let backupBoardPy = PythonObject(backupBoard)
    
    let response = file.is_new_board_valid(boardPy, backupBoardPy, wordsPlaced)
    let isValid = Bool(response[0]) ?? false
    let score = Int(response[1]) ?? 0

    // Extract the words formed
    var wordsFormed: [String] = []
    let wordsPy = response[2]
    if wordsPy != Python.None {
        for wordPy in wordsPy {
            if let word = String(wordPy) {
                wordsFormed.append(word)
            }
        }
    }

    return [isValid, score, wordsFormed]
}



func shuffle_tiles(tiles: [String], mode: String) -> [String] {
    // Path to your Python files directory
    let pathToPythonFile = pathToPythonFiles
    let pythonFile = "shuffle_tiles" // Name of your Python file without '.py' extension
    
    // Import Python sys module and append the path to your Python files
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)
    
    let file = Python.import(pythonFile)
    
    let tilesPy = PythonObject(tiles)
    
    let response = file.shuffle_tiles(tilesPy, mode)
    
    var shuffledTiles = [String]()
    for item in response {
        if let strItem = String(item) {
            shuffledTiles.append(strItem)
        }
    }
    
    return shuffledTiles
}

func changeTiles(availableLetterCounts: [String: Int], playerTiles: [String]) -> [Any] {
    let pathToPythonFile = pathToPythonFiles  // Ensure this variable is defined in your code
    let pythonFile = "change_tiles"
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)
    
    let file = Python.import(pythonFile)
    
    // Convert Swift dictionaries and arrays to Python equivalents
    let availableLetterCountsPy = PythonObject(availableLetterCounts)
    let playerTilesPy = PythonObject(playerTiles)
    
    // Call the Python function
    let response = file.change_tiles(availableLetterCountsPy, playerTilesPy)
    
    // Parse response to update Swift variables
    var updatedAvailableLetterCounts: [String: Int] = [:]
    var updatedPlayerTiles: [String] = []
    
    // Access the Python dictionary for available letter counts
    let newAvailableCounts = response[0]
    for key in newAvailableCounts.keys() {
        if let letter = String(key), let count = Int(newAvailableCounts[key]) {
            updatedAvailableLetterCounts[letter] = count
        }
    }
    
    // Update playerTiles in Swift
    let newPlayerTiles = response[1]
    for tile in newPlayerTiles {
        if let tileStr = String(tile) {
            updatedPlayerTiles.append(tileStr)
        }
    }
    
    return [updatedAvailableLetterCounts, updatedPlayerTiles]
}

func findCPUMoves(board: [[String]], cpuLetters: [String], wordsPlaced: Int) -> [Any] {
//    print("==============================================")
//    print(board)
//    print(cpuLetters)
//    print(wordsPlaced)
    
    let pathToPythonFile = pathToPythonFiles  // Update this path
    let pythonFile = "find_cpu_moves" // Update this with your Python file name without '.py'
    
    let sys = Python.import("sys")
    sys.path.append(pathToPythonFile)
    
    // Import your Python file
    let file = Python.import(pythonFile)
    
    // Convert Swift arrays to Python objects
    let boardPy = PythonObject(board)
    let cpuLettersPy = PythonObject(cpuLetters)
    let wordsPlacedPy = PythonObject(wordsPlaced)
//    print(boardPy)
//    print(cpuLettersPy)
//    print(wordsPlacedPy)
//    print("==============================================")
    // Call the Python function
    let response = file.find_cpu_moves(boardPy, cpuLettersPy, wordsPlacedPy)
    
    print(response)
    
    // Initialize the result array
    var resultArray: [Any] = []
    
    // Process the response
    if response.count == 5 {
        // Extract elements from the response
        let word = String(response[0]) ?? ""
        let row = Int(response[1]) ?? -1
        let col = Int(response[2]) ?? -1
        let isHorizontal = Bool(response[3]) ?? false
        let score = Int(response[4]) ?? -1
        
        resultArray.append(word)
        resultArray.append(row)
        resultArray.append(col)
        resultArray.append(isHorizontal)
        resultArray.append(score)
    } else {
        resultArray = []
    }
    
    return resultArray
}

