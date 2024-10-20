#!/bin/bash

# Load words from the file
word_file="words.txt"
words=($(cat "$word_file"))
# Select a random word
word=${words[RANDOM % ${#words[@]}]}
# Prepare variables for the game
word_length=${#word}
guessed_word=$(printf '_%.0s' $(seq 1 $word_length)) # Create a string of underscores
attempts=6
guessed_letters=()

echo "Welcome to Hangman!"
echo "Guess the word: $guessed_word"

# Game loop
while [[ $attempts -gt 0 && $guessed_word =~ '_' ]]; do
    read -p "Enter a letter: " letter
    # Check if the letter has already been guessed
    if [[ " ${guessed_letters[*]} " =~ " $letter " ]]; then
        echo "You already guessed that letter!"
        continue
    fi
    guessed_letters+=("$letter")

    # Check if the letter is in the word
    if [[ $word == *"$letter"* ]]; then
        echo "Good guess!"
        # Update the guessed word
        for ((i = 0; i < word_length; i++)); do
            if [[ ${word:i:1} == "$letter" ]]; then
                # Update the guessed word at the correct position
                guessed_word="${guessed_word:0:i}${letter}${guessed_word:i + 1}"
            fi
        done
    else
        ((attempts--))
        echo "Wrong guess! Attempts left: $attempts"
    fi

    # Display the current guessed word with spaces between letters
    echo "Current word: ${guessed_word//_/ }"
done

# End of the game
if [[ $guessed_word == "$word" ]]; then
    echo "Congratulations! You guessed the word '$word'."
else
    echo "You lost! The word was '$word'."
fi
