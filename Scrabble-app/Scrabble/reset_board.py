# O(1) - Import statement is constant time
import sys

'''
---- Board Tiles Encodings ----
available tile = any number from below
empty tile (no multiplier) -> 0
center -> 1
double letter -> 2
triple letter -> 3
double word -> 4
triple word -> 5
'''

# Average and Worst runtime complexity: 0(1) - since the board has a fixed size of 15x15
def reset_board() -> list[list[str]]:
    # O(1) - Creates a fixed 15×15 2D list
    board = [["0" for _ in range(15)] for _ in range(15)]

    # O(1) - Fixed-size list with exactly 24 coordinates
    double_letter_coords = [
        (0, 3), (0, 11), (2, 6), (2, 8), (3, 0), (3, 7), (3, 14), (6, 2), (6, 6), (6, 8), (6, 12), (7, 3), (7, 11), (8, 2),
        (8, 6), (8, 8), (8, 12), (11, 0), (11, 7), (11, 14), (12, 6), (12, 8), (14, 3), (14, 11)
    ]

    # O(1) - Fixed-size list with exactly 12 coordinates
    triple_letter_coords = [(1, 5), (1, 9), (5, 1), (5, 5), (5, 9), (5, 13), (9, 1), (9, 5), (9, 9), (9, 13), (13, 5), (13, 9)]

    # O(1) - Fixed-size list with exactly 16 coordinates
    double_word_coords = [
        (1, 1), (1, 13), (2, 2), (2, 12), (3, 3), (3, 11), (4, 4), (4, 10), (10, 4), (10, 10), (11, 3), (11, 11),
        (12, 2), (12, 12), (13, 1), (13, 13)
    ]

    # O(1) - Fixed-size list with exactly 8 coordinates
    triple_word_coords = [(0, 0), (0, 7), (0, 14), (7, 0), (7, 14), (14, 0), (14, 7), (14, 14)]

    # O(1) - Single fixed array access and assignment
    board[7][7] = "1"

    # O(1) - Loop through fixed 24 coordinates
    for row, col in double_letter_coords:
        board[row][col] = "2"

    # O(1) - Loop through fixed 12 coordinates
    for row, col in triple_letter_coords:
        board[row][col] = "3"

    # O(1) - Loop through fixed 16 coordinates 
    for row, col in double_word_coords:
        board[row][col] = "4"

    # O(1)  - Loop through fixed 8 coordinates
    for row, col in triple_word_coords:
        board[row][col] = "5"

    # O(1) - Return reference to the board
    return board

# Overall function runtime complexity: O(1)
# - Board size is fixed at 15×15
# - All coordinate lists have fixed sizes
# - All loops iterate through a constant number of elements
# - No operations depend on variable input

