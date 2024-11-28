#Appending is considered O(1) even though it is O(1) amortized 
from typing import List
import os

# O(1) - Dictionary initialization with fixed size (26 letters)
# Creating a dictionary with a fixed number of key-value pairs is constant time
letter_points = {
        "A": 1, "E": 1, "I": 1, "L": 1, "N": 1, "O": 1, "R": 1, "S": 1, "T": 1, "U": 1,
        "D": 2, "G": 2,
        "B": 3, "C": 3, "M": 3, "P": 3,
        "F": 4, "H": 4, "V": 4, "W": 4, "Y": 4,
        "K": 5,
        "J": 8, "X": 8,
        "Q": 10, "Z": 10
    }

    # Worst and average time complexity is O(n^2) 
    # O(m x n) gets discarded since m is always going to be less than n
def is_new_board_valid(board: List[List[str]], backup_board: List[List[str]], words_placed: int) -> List:
    
    # O(1) - Constant time assignment
    board_size = len(board)
    new_letters_indices = []

    # Collect new letters placed on the board
    # O(n^2) - Nested loop through entire board size. With n being the length of the 
    # board that is being passed as a parameter. 
    for i in range(board_size):
        for j in range(board_size):
            if board[i][j] != backup_board[i][j]:
                new_letters_indices.append((i, j))
                
    # O(1) - Early return check
    if not new_letters_indices:
        return [False, 0, []]

    # Determine if the word is horizontal or vertical
    # O(m) where m is number of new letters / size of the new_letters_indices array
    rows = [i for i, j in new_letters_indices]
    cols = [j for i, j in new_letters_indices]

    # O(m) set creation 
    is_horizontal = len(set(rows)) == 1
    is_vertical = len(set(cols)) == 1

    # O(1) - Constant time check
    if not is_horizontal and not is_vertical:
        return [False, 0, []]

    # O(1) - Constant time check
    words_formed = []

    # Load the dictionary
    # O(d) where d is dictionary size, since it is constant O(1)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    dictionary_path = os.path.join(script_dir, 'dictionary.txt')
    with open(dictionary_path, 'r') as file:
        content = file.read().splitlines()
    scrabble_words_set = set(word.upper() for word in content)

    
    # Function to calculate word score with multipliers
    #For worst and average case: O(w) being w the length of word_positions
    def calculate_word_score(word_positions):
        word_score = 0
        word_multiplier = 1
        
        #O(w) being w the length of word_positions
        for r, c in word_positions:
            letter = board[r][c]
            letter_point = letter_points.get(letter.upper(), 0)
            letter_multiplier = 1
            
            #O(1) for if statement 
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
    #O(m x p) m being new_letters indices and p being (-1,0),(1,0),(0,-1),(0,1).
    #So the overall complexity becomes O(m)
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
    # O(1) - list initialization
    word_positions = []

    # O(n)
    if is_horizontal:
        
        # O(1) - assignments 
        row = rows[0]
        min_col = min(cols) #O(n) min function
        max_col = max(cols) #O(n) max function

        # Extend left
        # O(n) - traverse up to n cells
        col = min_col - 1
        while col >= 0 and board[row][col].isalpha():
            min_col = col
            col -= 1

        # Extend right
        # O(n) - traverse up to n cells
        col = max_col + 1
        while col < board_size and board[row][col].isalpha():
            max_col = col
            col += 1

        # Form the word and record positions
        # O(n) - iterate up to n cells
        new_word = ''
        for col in range(min_col, max_col + 1):
            new_word += board[row][col]
            word_positions.append((row, col))

    # O(n)
    elif is_vertical:
        # O(1) - assignments
        col = cols[0]
        min_row = min(rows)
        max_row = max(rows)

        # Extend upwards
        # O(n) - traverse up to n cells
        row = min_row - 1
        while row >= 0 and board[row][col].isalpha():
            min_row = row
            row -= 1

        # Extend downwards
        # O(n) - traverse up to n cells
        row = max_row + 1
        while row < board_size and board[row][col].isalpha():
            max_row = row
            row += 1

        # Form the word and record positions
        # O(n) - iterate up to n cells
        new_word = ''
        for row in range(min_row, max_row + 1):
            new_word += board[row][col]
            word_positions.append((row, col))
    else:
        return [False, 0, []]

    # Add the main word to words_formed
    #O(1) - appending 
    words_formed.append((new_word, word_positions))

    # Check if the main word is valid
    # O(1) - if statement 
    if new_word.upper() not in scrabble_words_set:
        return [False, 0, [new_word]]

    # Check for cross words
    # O(m * n) being m new_letters_indices and n the rows  
    for i, j in new_letters_indices:
        if is_horizontal:
            # For horizontal word, check vertical cross words at each new letter
            #O(1) - assignment
            cross_word = board[i][j]
            cross_positions = [(i, j)]

            # Extend upwards
            #O(n) being n the number of rows
            row = i - 1
            while row >= 0 and board[row][j].isalpha():
                cross_word = board[row][j] + cross_word
                cross_positions.insert(0, (row, j))
                row -= 1

            # Extend downwards
            #O(n) being n the number of rows
            row = i + 1
            while row < board_size and board[row][j].isalpha():
                cross_word += board[row][j]
                cross_positions.append((row, j))
                row += 1
            
            # O(1) - if statements 
            if len(cross_word) > 1:
                if cross_word.upper() not in scrabble_words_set:
                    return [False, 0, [cross_word]]
                words_formed.append((cross_word, cross_positions))
        
        elif is_vertical:
            # For vertical word, check horizontal cross words at each new letter
            # O(1) - assignment
            cross_word = board[i][j]
            cross_positions = [(i, j)]

            # Extend left
            # O(n) being n the number of cols
            col = j - 1
            while col >= 0 and board[i][col].isalpha():
                cross_word = board[i][col] + cross_word
                cross_positions.insert(0, (i, col))
                col -= 1

            # Extend right
            # O(n) being n the number of cols
            col = j + 1
            while col < board_size and board[i][col].isalpha():
                cross_word += board[i][col]
                cross_positions.append((i, col))
                col += 1
            # 0(1) - if statement
            if len(cross_word) > 1:
                if cross_word.upper() not in scrabble_words_set:
                    return [False, 0, [cross_word]]
                words_formed.append((cross_word, cross_positions))

    # Calculate total score with multipliers using calculate_word_score
    
    # O(w) where w is total words formed - Calculate final score
    total_score = 0
    for word, positions in words_formed:
        word_score = calculate_word_score(positions)
        total_score += word_score

    # O(w) - Create final word list and return
    return [True, total_score, [w for w, _ in words_formed]]
