#Appending is considered O(1) even though it is O(1) amortized 

# O(1) import statement
import numpy 

#Average and worst case is 0(s) where s is the total letters in bag 
def get_letters_from_bag(available_letter_counts: dict, player_letters: int) -> list[dict, str]:
    
    #O(1) - Arithmetic operations
    missing_letters = 7 - player_letters 

    # create array with available letters to use numpy.random.choice()
    #O(1) - initialize array 
    available_letters_arr = [] 
    
    # O(s) - create an array by appending each letter value times
    for key, value in available_letter_counts.items():
        for _ in range (value):
            available_letters_arr.append(key)

    #O(1) - fixed dictionary size 
    if len(available_letters_arr) < missing_letters: 
        available_letter_counts = {
            "A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0,
            "H": 0, "I": 0, "J": 0, "K": 0, "L": 0, "M": 0, "N": 0,
            "O": 0, "P": 0, "Q": 0, "R": 0, "S": 0, "T": 0, "U": 0,
            "V": 0, "W": 0, "X": 0, "Y": 0, "Z": 0
        }
        return [available_letter_counts, available_letters_arr]
    else:
        # O(k) being k missing_letters between 1 and 7
        random_letters = numpy.random.choice(available_letters_arr,size=missing_letters)

        # update player's tiles
        # O(k) being k missing_letters between 1 and 7
        for letter in random_letters:
            available_letter_counts[letter]-=1

        return [available_letter_counts, random_letters]