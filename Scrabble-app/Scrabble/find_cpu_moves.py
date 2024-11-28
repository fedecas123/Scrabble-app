from itertools import permutations, combinations
from typing import List
import os

letter_points = {
            "A": 1, "E": 1, "I": 1, "L": 1, "N": 1, "O": 1, "R": 1, "S": 1, "T": 1, "U": 1,
            "D": 2, "G": 2,
            "B": 3, "C": 3, "M": 3, "P": 3,
            "F": 4, "H": 4, "V": 4, "W": 4, "Y": 4,
            "K": 5,
            "J": 8, "X": 8,
            "Q": 10, "Z": 10
        }


"""

COMPLEXITY ANALYSIS OF BUILT-IN IDENTIFIERS (DATA STRUCTURES & FUNCTIONS):
Note: if any line of the code is not analyzed, its complexity is likely referenced in the following summary:

- Arrays:
    - Appending: 
        - Best case: O(1) (amortized; only for python lists!)
        - Worst case: O(n) (copying over the array)
        - Average case: O(n) 
      - Find max/min:
            - Best case: O(1) (amortized; you get the max/min once then when you append compare and update if needed)
            - Worst case: O(n) (you have to iterate through the array; usually at the beginning)
            - Average case: O(n) 
- Sets:
    - Insertion:
        - Best case: O(1) (amortized; hash function is sufficiently good that collisions are rare; extends to sets and dicts)
        - Worst case: O(n) (continual collisions)
        - Average case: O(n) 
    - Lookup: 
        - Best case: O(1) (amortized)
        - Worst case: O(n) (continual collisions)
        - Average case: O(n) 
- Dictionary:
    - Lookup: 
        - Best case: O(1) (amortized)
        - Worst case: O(n) (continual collisions)
        - Average case: O(n) 
    - Insertion:
        - Best case: O(1) (amortized)
        - Worst case: O(n) (continual collisions)
        - Average case: O(n) 
- Sorting: 
    - Time: O(n*log n) (for merge sort)
- Combinations: 
    - O(n! / ((n-r)! * r!))
- Permutations: 
    - O(n! / (n-r)!)
- isalpha() and isdigit() and isupper()
      - Best case: O(1)
      - Worst case: O(n) (continual collisions)
      - Average case: O(n) 
- .upper() and .lower() 
      - Best case: O(1) (one single character)
      - Worst case: O(n) (length of string is n)
      - Average case: O(n) (length of string is n)
- .join()
      - Best case: O(1) (one single character)
      - Worst case: O(n) (length of string is n)
      - Average case: O(n) (length of string is n)
- .split()

- enumerate()
      - Best case: O(1) (iterable is of length 1)
      - Worst case: O(n) (length of iterable is n)
      - Average case: O(n) (length of iterable is n)
- .copy()
      - Best case: O(1) (single item)
      - Worst case: O(n) (length of array is n)
      - Average case: O(n) (length of array is n)
- len()
      - Best case, worst case, average case: O(1)
- range()
      - Best case, worst case, average case: O(1)
"""

class LetterSort:  # For sorting CPU letters by points
    def sorting(self, arr):
        n = len(arr)
        if n <= 1:
            return arr
            
        mid = n // 2
        left_branch = self.sorting(arr[:mid])
        right_branch = self.sorting(arr[mid:])
        return self.merge(left_branch, right_branch)

    def merge(self, left, right):
        output_arr = list()
        n_left = len(left)
        n_right = len(right)
        i = j = 0

        while i < n_left and j < n_right:
            if letter_points.get(left[i].upper(), 0) >= letter_points.get(right[j].upper(), 0):
                output_arr.append(left[i])
                i += 1
            else:
                output_arr.append(right[j])
                j += 1

        output_arr.extend(left[i:])
        output_arr.extend(right[j:])
        return output_arr

class WordSort:  # For sorting words by total points
    def sorting(self, arr):
        n = len(arr)
        if n <= 1:
            return arr
            
        mid = n // 2
        left_branch = self.sorting(arr[:mid])
        right_branch = self.sorting(arr[mid:])
        return self.merge(left_branch, right_branch)

    def merge(self, left, right):
        output_arr = list()
        n_left = len(left)
        n_right = len(right)
        i = j = 0

        while i < n_left and j < n_right:
            left_word_score = sum(letter_points.get(c.upper(), 0) for c in left[i])
            right_word_score = sum(letter_points.get(c.upper(), 0) for c in right[j])
            
            if left_word_score >= right_word_score:
                output_arr.append(left[i])
                i += 1
            else:
                output_arr.append(right[j])
                j += 1

        output_arr.extend(left[i:])
        output_arr.extend(right[j:])
        return output_arr

"""
Overall Complexity Analysis:

While the algorithm performs operations that appear to be O(L! + m * n² * w), 
all variables are bounded by Scrabble game rules:
- L ≤ 7 (maximum letters per player)
- n = 15 (fixed board size)
- w ≤ 15 (maximum word length)
- m is bounded by possible words from 7 letters
"""
def find_cpu_moves(board: List[List[str]], cpu_letters: List[str], words_placed: int) -> List:
    
    def is_new_board_valid(board: List[List[str]], backup_board: List[List[str]], words_placed: int) -> List:
        
        board_size = len(board)
        new_letters_indices = []

        # Collect new letters placed on the board
        for i in range(board_size):
            for j in range(board_size):
                if board[i][j] != backup_board[i][j]:
                    new_letters_indices.append((i, j))

        if not new_letters_indices:
            return [False, 0, []]

        # Determine if the word is horizontal or vertical
        rows = [i for i, j in new_letters_indices]
        cols = [j for i, j in new_letters_indices]

        is_horizontal = len(set(rows)) == 1
        is_vertical = len(set(cols)) == 1

        if not is_horizontal and not is_vertical:
            return [False, 0, []]

        words_formed = []

        # Load the dictionary
        script_dir = os.path.dirname(os.path.abspath(__file__))
        dictionary_path = os.path.join(script_dir, 'dictionary.txt')
        with open(dictionary_path, 'r') as file:
            content = file.read().splitlines()
        scrabble_words_set = set(word.upper() for word in content)

        # Function to calculate word score with multipliers
        def calculate_word_score(word_positions):
            word_score = 0
            word_multiplier = 1
            for r, c in word_positions:
                letter = board[r][c]
                letter_point = letter_points.get(letter.upper(), 0)
                letter_multiplier = 1

                if (r, c) in new_letters_indices:
                    multiplier = backup_board[r][c]
                    if multiplier == '2':
                        letter_multiplier = 2  # Double letter score
                    elif multiplier == '3':
                        letter_multiplier = 3  # Triple letter score
                    elif multiplier == '4':
                        word_multiplier *= 2  # Double word score
                    elif multiplier == '5':
                        word_multiplier *= 3  # Triple word score

                word_score += letter_point * letter_multiplier

            return word_score * word_multiplier

        # Check for invalid clusters around new letters
        for i, j in new_letters_indices:
            adjacent_letters = 0
            # Check orthogonal neighbors
            for dx, dy in [(-1,0),(1,0),(0,-1),(0,1)]:
                ni, nj = i + dx, j + dy
                if 0 <= ni < board_size and 0 <= nj < board_size:
                    if board[ni][nj].isalpha():
                        adjacent_letters += 1
            if adjacent_letters > 2:
                return [False, 0, []]

        # Form the main word including existing letters
        word_positions = []
        if is_horizontal:
            row = rows[0]
            min_col = min(cols)
            max_col = max(cols)

            # Extend left
            col = min_col - 1
            while col >= 0 and board[row][col].isalpha():
                min_col = col
                col -= 1

            # Extend right
            col = max_col + 1
            while col < board_size and board[row][col].isalpha():
                max_col = col
                col += 1

            # Form the word and record positions
            new_word = ''
            for col in range(min_col, max_col + 1):
                new_word += board[row][col]
                word_positions.append((row, col))

        elif is_vertical:
            col = cols[0]
            min_row = min(rows)
            max_row = max(rows)

            # Extend upwards
            row = min_row - 1
            while row >= 0 and board[row][col].isalpha():
                min_row = row
                row -= 1

            # Extend downwards
            row = max_row + 1
            while row < board_size and board[row][col].isalpha():
                max_row = row
                row += 1

            # Form the word and record positions
            new_word = ''
            for row in range(min_row, max_row + 1):
                new_word += board[row][col]
                word_positions.append((row, col))
        else:
            return [False, 0, []]

        # Add the main word to words_formed
        words_formed.append((new_word, word_positions))

        # Check if the main word is valid
        if new_word.upper() not in scrabble_words_set:
            return [False, 0, [new_word]]

        # Check for cross words
        for i, j in new_letters_indices:
            if is_horizontal:
                # For horizontal word, check vertical cross words at each new letter
                cross_word = board[i][j]
                cross_positions = [(i, j)]

                # Extend upwards
                row = i - 1
                while row >= 0 and board[row][j].isalpha():
                    cross_word = board[row][j] + cross_word
                    cross_positions.insert(0, (row, j))
                    row -= 1

                # Extend downwards
                row = i + 1
                while row < board_size and board[row][j].isalpha():
                    cross_word += board[row][j]
                    cross_positions.append((row, j))
                    row += 1

                if len(cross_word) > 1:
                    if cross_word.upper() not in scrabble_words_set:
                        return [False, 0, [cross_word]]
                    words_formed.append((cross_word, cross_positions))
            elif is_vertical:
                # For vertical word, check horizontal cross words at each new letter
                cross_word = board[i][j]
                cross_positions = [(i, j)]

                # Extend left
                col = j - 1
                while col >= 0 and board[i][col].isalpha():
                    cross_word = board[i][col] + cross_word
                    cross_positions.insert(0, (i, col))
                    col -= 1

                # Extend right
                col = j + 1
                while col < board_size and board[i][col].isalpha():
                    cross_word += board[i][col]
                    cross_positions.append((i, col))
                    col += 1

                if len(cross_word) > 1:
                    if cross_word.upper() not in scrabble_words_set:
                        return [False, 0, [cross_word]]
                    words_formed.append((cross_word, cross_positions))

        # Calculate total score with multipliers using calculate_word_score
        total_score = 0
        for word, positions in words_formed:
            word_score = calculate_word_score(positions)
            total_score += word_score

        return [True, total_score, [w for w, _ in words_formed]]

    # Determine the path to the dictionary file
    script_dir = os.path.dirname(os.path.abspath(__file__))
    dictionary_path = os.path.join(script_dir, 'dictionary.txt')

    # O(d) - Where d is the number of words in the dictionary, since the dictionary is fixed O(1)
    try:
        with open(dictionary_path, 'r') as file:
            content = file.read().splitlines()
    except Exception as e:
        return []

    scrabble_words_set = set(word.upper() for word in content)

    # O(1) - Assignment and Initialization
    board_size = len(board)
    best_move = []
    max_score = -1

    #Implementing a greedy algorithm for move generation

    # O(n log n) - Sorting CPU letters using merge sort
    # where n is number of CPU letters (typically ≤ 7 in Scrabble)
    letter_sorter = LetterSort()
    sorted_cpu_letters = letter_sorter.sorting(cpu_letters)

    # Generate possible words using high-value letters first

    # This section appears to be O(L!), but since L ≤ 7 in Scrabble,
    # the maximum operations are bounded:
    # - Maximum combinations: 2^7 = 128
    # - Maximum permutations per combination: 7! = 5040
    # Therefore this entire section is O(1)
    possible_words = set()
    for i in range(len(sorted_cpu_letters), 0, -1):
        for letters in combinations(sorted_cpu_letters, i):  # O(L! / (i!(L-i)!))
            # Generate permutations of selected letters
            perms = set(permutations(letters)) # O(i!)
            for perm in perms:  # O(i!)
                word = ''.join(perm)
                if word.upper() in scrabble_words_set:
                    possible_words.add(word.upper())
        if possible_words:
            break  # Prioritize longer words with high-value letters

    # Sort possible words by their potential score
    # O(m log m) - Sorting possible words where m is number of possible words
    word_sorter = WordSort()
    possible_words = word_sorter.sorting(list(possible_words))


    # Originally analyzed as O(m * n^2 * w), but let's break it down:
    # - n = 15 (fixed Scrabble board size)
    # - w ≤ n = 15 (maximum word length)
    # - m is limited by the number of possible words from 7 letters
    # Therefore this section is also O(1) since all variables are bounded
    for word in possible_words:  # O(m)
        word_length = len(word) # O(1)

        # Generate potential positions to place the word
        positions = [] # O(1)

        # Position generation
        if words_placed == 0: # O(1)
            # First move must cover the center
            center = board_size // 2
            positions.append((center, max(0, center - word_length + 1), True))  # Horizontal
            positions.append((max(0, center - word_length + 1), center, False))  # Vertical
        else:
            # Find all positions where the word can be placed by intersecting existing letters
             # Find intersections: O(n^2 * w)
            for i in range(board_size):# O(n)
                for j in range(board_size): # O(n)
                    if board[i][j].isalpha() and board[i][j].upper() in word: # O(1)
                        indices = [idx for idx, c in enumerate(word) if c == board[i][j].upper()] # O(w)
                        for idx in indices: # Position generation for each intersection: O(1)
                            # Attempt to place horizontally
                            start_col = j - idx
                            if start_col >= 0 and start_col + word_length <= board_size:
                                positions.append((i, start_col, True))
                            # Attempt to place vertically
                            start_row = i - idx
                            if start_row >= 0 and start_row + word_length <= board_size:
                                positions.append((start_row, j, False))

        # Try each position: O(p * n^2) where p is number of positions
        for position in positions: # O(p)
            i, j, is_horizontal = position
            # Board copying: O(n^2)
            temp_board = [row.copy() for row in board]
            
            # Word placement attempt: O(w)
            can_place = True
            used_board_letter = False
            for idx, letter in enumerate(word):
                r, c = (i, j + idx) if is_horizontal else (i + idx, j)
                cell = temp_board[r][c]
                if cell.isalpha():  # O(1)
                    if cell.upper() != letter: # O(1)
                        can_place = False
                        break
                    else:
                        used_board_letter = True
                else:
                    temp_board[r][c] = letter
            
            # Again, appears to be O(n^2) but since n = 15
            # this is effectively O(1)
            if can_place and (used_board_letter or words_placed == 0):
                is_valid_result = is_new_board_valid(temp_board, board, words_placed)
                if len(is_valid_result) == 3:
                    is_valid, score, words_formed = is_valid_result
                    if is_valid and isinstance(score, int) and score > max_score:
                        max_score = score
                        best_move = [word, i, j, is_horizontal, score]

        if best_move:
            break  # Stop after finding the best move for the highest-scoring word

    if best_move:
        return best_move
    else:
        # No valid moves found, return an empty list
        return []

