# Scrabble Game Project

## Project overview

Our project implements data structures and algorithms learned in class to create the word game Srabble. The python code handles all the game logic, such as board management, tile handling, word validation, and scoring. We use Swift to provide a GUI to the players, connecting the backend to the frontend using the PythonKit library.

## Features
- Fully functional Scrabble board: Includes special tiles, such as double and triple letter scores.
- Tile management: Features shuffling, sorting, and exchanging tiles.
- Word validation: Validates placed words against a Scrabble dictionary.
- Automated scoring: Calculates scores for both primary words and crosswords formed during a player turn.
- Standard tile bag: Implements the official Scrabble tile distribution.
- Modular design: Functions are organized for easy reuse and integration.

## Prerequisites
- Python: Version 3.8 or higher.
- Swift (downloaded with Xcode): Latest version with PythonKit installed.
- Xcode: Required for running the Swift frontend.

## Setup and Usage
### Python Backend Setup
Download all the files from the provided github repository, and uncompress the file
Download Xcode
Open Xcode, and select “Open Existing Project”
Through the file explorer window, navigate to the previously downloaded github files.
Through the Xcode IDE, click on the overarching project file on the file explorer tab (top right)
Click on “Signing & Capabilities” and click on “Team” -> “Add an account”.
Type in your Apple Account details, then click “Next”
Once your account has successfully been added, close the setting pop up window, and return to the “Signing & Capabilities” tab.
Once again, click on the “Team” dropdown menu and click on your newly created team. This should be labelled with “Personal Team”
Now, click the run symbol on the top right
The user will be prompted to enter their absolute path to the python files. Make sure that your path looks like "/Users/.../Scrabble-app"
Once entered, press "Continue" and Scrabble will show up! Have fun!

## Functions overview

### Function: change_tiles
**Purpose**
This function is to allow a play to swap the tiles they currently have for new tiles from the tile bag. First, it returns the player's tiles to the bag, which updates the letter count of the bag, then it selects a new set of tiles for the player. If there aren't enough letters left, the function just gives the player all remaining tiles instead. The handling of this edge case allows the game to continue even if the bag runs out of letters.

**Parameters**
- `available_letter_counts` (dict): A dictionary where the keys are letters and the values are the counts of those letters in the tile bag.
- `player_tiles` (list[str]): A list of the tiles the player currency has.

**Returns**
List:
- Updated `available_letter_counts` (dict): The remaining letters in the tile bag after the exchange.
- `new_player_tiles` (list[str]): The new tiles the player will get.

**Average Case Complexity**
O(s+p)
- s: Total number of letters in the bag (creating available_letters_arr).
- p: Number of tiles the player exchanges.

**Worst Case Complexity**
O(s+p)
All letters in the bag are iterated, and all player's tiles are replaced.

### Function: get_letters_from_bag
**Purpose**
This function is to make sure that a player has the required amount of total lines (7), by adding more tiles from the tile bag. First it calculates how many more tiles the player needs, then it randomly selects that number of tiles from the letters that are in the bag. After it selects the tiles, it updates the tile bag by reducing the counts of the selected letters. We ensure error handling for the edge case of the bag not having enough tiles, giving the player the remaining tiles.

**Parameters**
- `available_letter_counts` (dict): A dictionary where the keys are letters and the values represent their counts in the tile bag.
- `player_letters` (int): The number of tiles the player currently has.

**Returns**
List:
- Updated `available_letter_counts` (dict): The remaining letters in the tile bag after giving tiles to the player.
- `random_letters` (list[str]): A list of the tiles added to the player's collection.

**Average Case Complexity**
O(s+k)
- s: Total number of letters in the tile bag (to make available_letters_arr).
- k: Number of missing tiles for the player (between 1 and 7).

**Worst Case Complexity**
O(s+k)
All letters in the bag are iterated to make available_letters_arr, and all missing tiles are updated.

### Function: is_new_board_valid
**Purpose**
This function is to make sure that a new word placed on the board follows all the game rules. It makes sure that the world is placed correctly, and validates the word using the dictionary of valid words. It then calculates the score and applies any multipliers for tiles, such as double or triple scores. It also checks and makes sure any crosswords made by the new word, to make sure all the formed words are valid

**Parameters**
- `board` (List[List[str]]): A 2D list, which is the current state of the Scrabble board with letters and multipliers.
- `backup_board` (List[List[str]]): A backup copy of the board before the move to be able to compare the changes made.
- `words_placed` (int): The number of words placed so far.

**Returns**
List:
- True or False (bool): Indicates whether the move is valid.
- `total_score` (int): The total score of the move if it is valid.
- `formed_words` (List[str]): A list of valid words made during the move.

**Average Case Complexity**
O(n^2), where n is the board size.
Most operations are dependent on the size of the board or the new letters placed.

**Worst Case Complexity**
O(n^2), where n is the board size.
The term O(m×p) comes from validating clusters and crosswords, where m is the number of new letters placed and p is the number of adjacent neighbors checked (a fixed constant, 4). So, O(m×p) simplifies to O(m) since p does not scale with the board size.
The O(m) term does not dominate O(n^2), unless m > n^2, which is impossible because m is always less than the number of cells on the board.
The O(n^2) term (coming from the nested iteration through the entire board) dominates all other terms, including O(m) and O(w) (word scoring), in the worst case.

### Function: reset_board
**Purpose**
This function is to create the Scrabble board itself, by initializing a 15 by 15 grid. To be able to indicate the special tiles, such as double or triple letters and scores, it assigns specific values and marks the center tile as the starting point of the game, which is part of Scrabble rules.

**Parameters**
None.

**Returns**
- `board` (list[list[str]]): A 15×15 2D list representing the Scrabble board with values for special tiles:
  - "0": Empty tile with no multiplier.
  - "1": Center tile.
  - "2": Double letter score.
  - "3": Triple letter score.
  - "4": Double word score.
  - "5": Triple word score.

**Average Case Complexity**
O(1):
The board size is fixed at 15×15, and all operations involve constant-size loops.

**Worst Case Complexity**
O(1):
Same as the average case because:
- The board dimensions are constant.
- All coordinate lists for multipliers are a fixed size.
- Loops iterate over fixed elements, and are not dependent on a variable.

### Function: reset_letter_count_in_bag
**Purpose**
This function is to set up the tile bag, by assigning each letter the starting count according to Scrabble rules. We end up with a dictionary, where each letter is a key, and its value is the number of tiles available for that letter. 

**Parameters**
None.

**Returns**
- `letter_count` (dict): A dictionary where the keys are letters of the alphabet. The values are the count of each letter in the tile bag.

**Average Case Complexity**
O(1):
The dictionary has a fixed size of 26 keys (one for each letter), so initialization is constant time.

**Worst Case Complexity**
O(1):
Same as the average case, because the dictionary's size is constant and not dependent on a variable.

### Function: shuffle_tiles
**Purpose**
This function is to sort or shuffle a list of Scrabble tiles based on the mode that the user chooses. The modes are:
- random: Shuffles the tiles randomly.
- bypoints: Sorts the tiles by their Scrabble point values (and alphabetically for ties).
- alphabetically: Sorts the tiles alphabetically.

**Parameters**
- `tiles` (list[str]): A list of Scrabble tiles to shuffle or sort.
- `mode` (str): The sorting or shuffling mode:
  - "random": Randomly shuffles the tiles.
  - "bypoints": Sorts tiles by their Scrabble point values.
  - "alphabetically": Sorts tiles alphabetically.

**Returns**
- `tiles` (list[str]): A list of tiles shuffled or sorted based on the selected mode.

**Average Case Complexity**
O(nlog⁡n):
- For "bypoints" and "alphabetically", sorting is done using mergesort, which has a time complexity of O(nlog⁡n).
- For "random", the random.shuffle function runs in O(n), which is dominated by O(nlog⁡n) in sorting modes.

**Worst Case Complexity**
O(nlog⁡n):
Same as the average case since mergesort consistently operates in O(nlog⁡n).
We implement mergesort over quicksort because the worst case complexity of O(nlogn) is faster than the worst case complexity of quicksort, which is O(n^2). Merge sort is used over other sorting algorithms such as insertion sort, sequential sort, bubble sort, etc, because it consistently performs at O(nlogn) and has a better time complexity

### Function: mergesort
**Purpose**
This function is a basic merge sort function, which sortd an array using a custom key by recursively dividing it into smaller parts, sorting each part, and merging them back in sorted order

**Parameters**
- `arr` (list): The list to be sorted.
- `key` (function, optional): A function that defines the sorting criteria for each element. Defaults to the identity function.

**Returns**
- `sorted_arr` (list): A sorted version of the list inputted based on the custom key.

**Average Case Complexity**
O(nlog⁡n):
Mergesort divides the array into halves recursively and merges them back together.

**Worst Case Complexity**
O(nlog⁡n):
Mergesort runs in O(nlog⁡n) regardless, due to its divide-and-conquer approach.

### Function: combine
**Purpose**
This function acts as a helper function for the mergesort function, and merges two sorted arrays into a single sorted array.

**Parameters**
- `left_arr` (list): The left sorted array.
- `right_arr` (list): The right sorted array.
- `key` (function, optional): A function defining the sorting criteria for elements. Defaults to the identity function.

**Returns**
- `merged_array` (list): A merged array containing all elements from left_arr and right_arr in sorted order.

**Average Case Complexity**
O(n):
The function iterates through all elements in left_arr and right_arr once.

**Worst Case Complexity**
O(n):
Same as the average case since merging is a linear operation.

## Function: find_cpu_moves
**Purpose**
This function is to find the best possible move in that moment for a CPU player, by leveraging greedy algorithm and evaluating all the possible words it can create using the tiles it has. It checks that the placements on the board are valid, calculates the scores for each word while taking into account any multipliers, and selects the move with the highest score. This way, the CPU maximizes its points for each turn.

**Parameters**
1. **board** (*List[List[str]]*): A 2D list representing the current state of the Scrabble board with letters and multipliers.
2. **cpu_letters** (*List[str]*): A list of letters available to the CPU for forming words.
3. **words_placed** (*int*): The number of words already placed on the board.

**Returns**
* **best_move** (*List*): Details of the CPU's best move, displayed for the user to input:
   * **word** (*str*): The highest scoring word the algorithm found.
   * **i**, **j** (*int*): The starting row and column for the word placement.
   * **is_horizontal** (*bool*): Whether the word is placed horizontally (True) or vertically (False).
   * **score** (*int*): The total score of the move.
* Returns an empty list ([]) if no valid move is found.

**Complexity**
* **Average Case Complexity**: O(L!⋅W+m⋅n^2⋅w)
   * L: Number of CPU letters (≤7).
   * W: Cost of dictionary lookups (average O(1)).
   * m: Number of possible words generated.
   * n: Size of the board (typically 15).
   * w: Maximum word length.

* **Worst Case Complexity**: O(L!⋅W+m⋅n^2⋅w)
   * Similar to the average case but accounts for more words and positions to validate.

**Steps**
1. **Sort CPU Letters**: The CPU letters are sorted by their scores using merge sort.
2. **Generate Words**: Permutations and combinations of the letters are used to find potential words, prioritized by length and points.
3. **Validate Words**: Each word is validated using the dictionary.
4. **Find Placement**: For every word, potential positions on the board are found and validated.
5. **Score Calculation**: If a valid move is found, its score is calculated, also with the multipliers.
6. **Select Best Move**: The move with the highest score is what is chosen in the end.

## General Notes

**Why Functions Are Repeated**
Many functions used in the CPU logic are duplicates of other functions used. This is due to the Swift integration. Since the Swift frontend uses PythonKit to communicate with Python, it requires all relevant functionality to be included within the CPU function itself for seamless execution.

**CPU Player Behavior**
The CPU functionality is not fully automated. It determines the optimal move by calculating the highest-scoring word, but only **displays the word** for the user. The player must manually input the suggested word to play against the CPU. This design keeps the interaction simple and avoids additional layers of automation, and allows us to focus on backend logic.