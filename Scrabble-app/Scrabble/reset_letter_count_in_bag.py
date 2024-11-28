# O(1) - Import statement is constant time
import sys

# O(1) - Function declaration is constant time
def reset_letter_count_in_bag() -> dict:
    # O(1) - Dictionary initialization with fixed size (26 letters)
    # Creating a dictionary with a fixed number of key-value pairs is constant time
    letter_count = {
        "A": 9, "B": 2, "C": 2, "D": 4, "E": 12, "F": 2, "G": 3,
        "H": 2, "I": 9, "J": 1, "K": 1, "L": 4, "M": 2, "N": 6,
        "O": 8, "P": 2, "Q": 1, "R": 6, "S": 4, "T": 6, "U": 4,
        "V": 2, "W": 2, "X": 1, "Y": 2, "Z": 1
    }
    
    # O(1) - Returning a reference to the dictionary is constant time
    return letter_count
