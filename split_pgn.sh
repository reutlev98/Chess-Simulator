# Reut Lev 207385741
#!/bin/bash

# Function to print usage and exit
usage() {
    echo "Usage: $0 <source_pgn_file> <destination_directory>"
    exit 1
}

# Function to check if a file exists
check_file() {
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' does not exist."
        exit 1
    fi
}

# Function to check if a directory exists or create it
check_or_create_dir() {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
        echo "Created directory '$1'."
    fi
}

# Function to split the PGN file into individual games
split_pgn() {
    local input_file="$1"
    local dest_dir="$2"
    local game_counter=1
    local game_content=""

    local base_filename
    base_filename=$(basename "$input_file" .pgn)

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "[Event "* ]]; then
            if [[ -n "$game_content" ]]; then
                echo "$game_content" > "${dest_dir}/${base_filename}_${game_counter}.pgn"
                echo "Saved game to ${dest_dir}/${base_filename}_${game_counter}.pgn"
                game_counter=$((game_counter + 1))
                game_content=""
            fi
        fi
        game_content+="$line"$'\n'
    done < "$input_file"

    if [[ -n "$game_content" ]]; then
        echo "$game_content" > "${dest_dir}/${base_filename}_${game_counter}.pgn"
        echo "Saved game to ${dest_dir}/${base_filename}_${game_counter}.pgn"
    fi

    echo "All games have been split and saved to '$dest_dir'."
}

# Main script logic

# Validate the number of arguments
if [[ "$#" -ne 2 ]]; then
    usage
fi

input_file="$1"
dest_dir="$2"

# Validate the existence of the source file
check_file "$input_file"

# Check or create the destination directory
check_or_create_dir "$dest_dir"

# Split the PGN file
split_pgn "$input_file" "$dest_dir"
