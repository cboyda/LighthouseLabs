"""
Given two strings, create a function that returns the total number of unique characters from the combined string.

Examples:
    count_unique_chars("apple", "play") ➞ 5
    "appleplay" has 5 unique characters:  "a", "e", "l", "p", "y"

    count_unique_chars("sore", "zebra") ➞ 7

    count_unique_chars("a", "soup") ➞ 5

Notes:
 - Careful with empty strings
 - All characters will be lowercase.

"""

def count_unique_chars(string_1, string_2):
    # merge strings
    mega_string = string_1 + string_2

    # count unique characters
    unique_count = 0
    unique_string = ""
    for letter in mega_string:
        if letter not in unique_string:
            unique_string += letter
            unique_count += 1
    return unique_count

count_unique_chars("a", "soup")