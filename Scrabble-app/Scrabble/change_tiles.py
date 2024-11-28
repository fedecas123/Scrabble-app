#Appending is considered O(1) even though it is O(1) amortized 

# O(1) - import library
import random


# Average and worst case: O(s) being s the total letters in the bag
  
def change_tiles(available_letter_counts: dict, player_tiles: list[str]) -> list[dict, list[str]]:
    # return the player's tiles back to the bag
    # O(n) where n is the length of player_tiles
    for tile in player_tiles:
        if tile in available_letter_counts:
            available_letter_counts[tile] += 1
        else:
            available_letter_counts[tile] = 1 

    # create list of available letters in the bag
    # O(1) - create array
    available_letters_arr = [] 
    
    # O(s) - create an array by appending each letter value times
    for key, value in available_letter_counts.items():
        for _ in range (value):
            available_letters_arr.append(key)

    tiles_needed = len(player_tiles)

    # O(1) - create array
    new_player_tiles = []

    # check if there are enough letters in the bag
    # O(p) - random.sample is O(p) where p is tiles_needed
    if len(available_letters_arr) >= tiles_needed:
        new_player_tiles = random.sample(available_letters_arr, tiles_needed)
    else:
        new_player_tiles = available_letters_arr  

    # Reduce the counts in the available pool for each tile given to the player.
    # O(p) - Update counts
    for tile in new_player_tiles:
        available_letter_counts[tile] -= 1

    # Return the updated tile pool and the new tiles for the player.
    return [available_letter_counts, new_player_tiles]

