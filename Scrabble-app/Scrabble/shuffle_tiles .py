import random  

# O(1) - Dictionary initialization with fixed size
letter_points = {
    "A": 1, "E": 1, "I": 1, "L": 1, "N": 1, "O": 1, "R": 1, "S": 1, "T": 1, "U": 1,
    "D": 2, "G": 2,
    "B": 3, "C": 3, "M": 3, "P": 3,
    "F": 4, "H": 4, "V": 4, "W": 4, "Y": 4,
    "K": 5,
    "J": 8, "X": 8,
    "Q": 10, "Z": 10
}


# Worst and Average time complexity: O(n log n) 
def mergesort(arr: list, key=lambda x: x, reverse=False) -> list:
    # O(1) - Base case check
    if len(arr) <= 1:
        return arr
        
    # O(1) - Calculate midpoint
    mid = len(arr) // 2
    
    # O(n log n) - Two recursive calls, each on half the input
    left = mergesort(arr[:mid], key, reverse)  # O(n/2 * log n)
    right = mergesort(arr[mid:], key, reverse) # O(n/2 * log n)
    
    # O(n) - Combining the sorted halves
    return combine(left, right, key, reverse)

# Time Complexity: O(n) where n is total length of both input arrays
def combine(left_arr: list, right_arr: list, key=lambda x: x, reverse=False) -> list:
    # O(1) - Array initialization and variable declarations
    final_array = [0] * (len(left_arr) + len(right_arr))
    left_idx = right_idx = result_idx = 0
    
    # O(n) - Main merging loop
    while left_idx < len(left_arr) and right_idx < len(right_arr):
        compare = key(left_arr[left_idx]) >= key(right_arr[right_idx]) if reverse else key(left_arr[left_idx]) <= key(right_arr[right_idx])
        if compare:
            final_array[result_idx] = left_arr[left_idx]
            left_idx += 1
        else:
            final_array[result_idx] = right_arr[right_idx]
            right_idx += 1
        result_idx += 1

    # O(n) - Copy remaining elements
    while left_idx < len(left_arr):
        final_array[result_idx] = left_arr[left_idx]
        left_idx += 1
        result_idx += 1

    # O(n) - Copy remaining elements
    while right_idx < len(right_arr):
        final_array[result_idx] = right_arr[right_idx]
        right_idx += 1
        result_idx += 1

    # O(1) - Return merged array
    return final_array

# Worst and Average time complexity: O(n log n) 
def shuffle_tiles(tiles: list[str], mode: str) -> list[str]:
    # O(1) - Mode check
    if mode == 'random':
        # O(n) - Random shuffle
        random.shuffle(tiles)
        return tiles
        
    # O(1) - Mode check
    elif mode == 'bypoints':
        # O(n log n) - Mergesort with point comparison
        return mergesort(tiles, 
                        key=lambda x: (letter_points.get(x.upper(), 0), x.upper()),
                        reverse=True) 
        
    # O(1) - Mode check
    elif mode == 'alphabetically':
        # O(n log n) - Mergesort with alphabetical comparison
        return mergesort(tiles, key=lambda x: x.upper())
    
    # O(1) - Default return
    return tiles
