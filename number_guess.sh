#!/bin/bash

DB="users.db"
DB_PATH="$HOME/.number_guessing_game/$DB"

mkdir -p ~/.number_guessing_game
if [ ! -f "$DB_PATH" ]; then
  touch "$DB_PATH"
fi

echo "Enter your username:"
read -r username

if [[ ${#username} -gt 22 ]]; then
  echo "Username too long (max 22 chars)."
  exit 1
fi

user_line=$(grep "^$username:" "$DB_PATH")

if [ -n "$user_line" ]; then
  games_played=$(echo "$user_line" | cut -d':' -f2)
  best_game=$(echo "$user_line" | cut -d':' -f3)
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
else
  echo "Welcome, $username! It looks like this is your first time here."
  games_played=0
  best_game=10000
fi

secret=$(( RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000:"

guess_count=0

while true; do
  read -r guess
  if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi
  guess_count=$((guess_count + 1))
  if [ "$guess" -eq "$secret" ]; then
    echo "You guessed it in $guess_count tries. The secret number was $secret. Nice job!"
    break
  elif [ "$guess" -gt "$secret" ]; then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done

games_played=$((games_played + 1))
if [ "$guess_count" -lt "$best_game" ]; then
  best_game=$guess_count
fi

if grep -q "^$username:" "$DB_PATH"; then
  sed -i "s/^$username:.*/$username:$games_played:$best_game/" "$DB_PATH"
else
  echo "$username:$games_played:$best_game" >> "$DB_PATH"
fi
