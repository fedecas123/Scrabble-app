def levenshtein_distance(word1: str, word2: str) -> int:
    # O(mn) space complexity - Creating the DP table
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # O(m) - Initializing first column
    for i in range(m + 1):
        dp[i][0] = i

    # O(n) - Initializing first row
    for j in range(n + 1):
        dp[0][j] = j
    
    # Fill the dp table
    # O(mn) - Main DP table filling
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = min(dp[i - 1][j] + 1,dp[i][j - 1] + 1,  dp[i - 1][j - 1] + 1)
                # deletion, insertion, substitution
    return dp[m][n]

def get_autocomplete_suggestions(partial_word: str, max_suggestions: int = 5, max_distance: int = 2) -> list[tuple[str, int]]:
    """
    Returns a list of tuples containing (suggested_word, distance).
    
    Args:
        partial_word: The partial or misspelled word to get suggestions for
        max_suggestions: Maximum number of suggestions to return
        max_distance: Maximum Levenshtein distance to consider
    """
    # O(d) where d is dictionary size
    with open('dictionary.txt', 'r') as file:
        dictionary = set(file.read().splitlines())
    
    suggestions = []
    partial_word = partial_word.upper()
    
    # First, find words that start with the partial word (prefix match)
    # O(d) where d is dictionary size - Finding prefix matches
    prefix_matches = [
        (word, 0) for word in dictionary 
        if word.startswith(partial_word)
    ]
    
    # If we have enough prefix matches, return them
    # O(p log p) where p is number of prefix matches - Sorting
    if len(prefix_matches) >= max_suggestions:
            ordered_matches = sorted(prefix_matches, key=lambda x: (x[1], len(x[0])))
            top_matches = ordered_matches[:max_suggestions]
       
            return top_matches
    
    # Otherwise, calculate Levenshtein distance for other words
     # O(d * L²) where L is average word length - Computing Levenshtein distances
    for word in dictionary:
        if abs(len(word) - len(partial_word)) > max_distance:
            continue
        
        distance = levenshtein_distance(partial_word, word)
        if distance <= max_distance:
            suggestions.append((word, distance))
    
    # Combine prefix matches and distance-based matches
     # O(s log s) where s is size of suggestions
    all_suggestions = prefix_matches + suggestions
    
    # Sort by distance first, then by word length
    return sorted(all_suggestions, key=lambda x: (x[1], len(x[0])))[:max_suggestions]

def autocomplete_word(partial_word: str) -> list[str]:
    """
    Main function to get autocomplete suggestions for a partial word.
    Returns a list of suggested words.
    """
    suggestions = get_autocomplete_suggestions(partial_word)
    return [word for word, _ in suggestions]

# Example usage and testing
if __name__ == "__main__":
    test_words = ["CATS", "HELZ", "QU", "SCRAB"]
    
    for word in test_words:
        print(f"\nSuggestions for '{word}':")
        suggestions = autocomplete_word(word)
        for suggestion in suggestions:
            print(f"  - {suggestion}")
