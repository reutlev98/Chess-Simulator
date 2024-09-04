# Reut Lev 207385741
#!/bin/bash

# Function to display the chessboard
display_board() {
    local board=("$@")
    echo "  a b c d e f g h"
    for ((i=0; i<8; i++)); do
        echo -n "$((8-i)) "
        for ((j=0; j<8; j++)); do
            echo -n "${board[i*8+j]} "
        done
        echo "$((8-i))"
    done
    echo "  a b c d e f g h"
}

# Initialize the board
initialize_board() {
    board=("r" "n" "b" "q" "k" "b" "n" "r"
           "p" "p" "p" "p" "p" "p" "p" "p"
           "." "." "." "." "." "." "." "."
           "." "." "." "." "." "." "." "."
           "." "." "." "." "." "." "." "."
           "." "." "." "." "." "." "." "."
           "P" "P" "P" "P" "P" "P" "P" "P"
           "R" "N" "B" "Q" "K" "B" "N" "R")
}

# Apply a move to the board
apply_move() {
    local move=$1
    local from="${move:0:2}"
    local to="${move:2:2}"
    
    # Convert chess notation to board indices
    local from_col=$(($(echo ${from:0:1} | tr 'a-h' '0-7')))
    local from_row=$((8 - ${from:1:1}))
    local to_col=$(($(echo ${to:0:1} | tr 'a-h' '0-7')))
    local to_row=$((8 - ${to:1:1}))
    local from_index=$((from_row * 8 + from_col))
    local to_index=$((to_row * 8 + to_col))
    # Move the piece
    board[to_index]=${board[from_index]}
    board[from_index]="."
}

# Reverse a move on the board
reverse_move() {
    local move=$1
    local from="${move:0:2}"
    local to="${move:2:2}"
    
    # Convert chess notation to board indices
    local from_col=$(($(echo ${from:0:1} | tr 'a-h' '0-7')))
    local from_row=$((8 - ${from:1:1}))
    local to_col=$(($(echo ${to:0:1} | tr 'a-h' '0-7')))
    local to_row=$((8 - ${to:1:1}))
    local from_index=$((from_row * 8 + from_col))
    local to_index=$((to_row * 8 + to_col))
    # Move the piece
    board[from_index]=${board[to_index]}
    board[to_index]="."
}

# Function to parse and reorder PGN metadata
parse_pgn() {
    local pgn_file=$1
    local metadata=()
    local moves=""
    # Read the PGN file line by line
    while IFS= read -r line; do
        # Check if the line contains metadata
        if [[ $line == \[*\] ]]; then
            # Add the metadata line to the array
            metadata+=("$line")
        # Check if the line contains moves
        elif [[ $line != "" ]]; then
            # Concatenate moves
            moves+="$line "
        fi
    done < "$pgn_file"

    # Print the reordered metadata
    echo "Metadata from PGN file:"
    for meta in "${metadata[@]}"; do
        case $meta in
            [Event\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [Site\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [Date\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [Round\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [White\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [Black\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [Result\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [BlackElo\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [ECO\ *) echo "$meta" ;;
        esac
    done
    for meta in "${metadata[@]}"; do
        case $meta in
            [WhiteElo\ *) echo "$meta" ;;
        esac
    done
    echo " "
    # Print the moves
    echo "$moves"
}


# Main script
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <pgn-file>"
    exit 1
fi

pgn_file=$1
# Read metadata and moves from PGN file
metadata=$(parse_pgn "$pgn_file" | head -n -1)
moves_string=$(parse_pgn "$pgn_file" | tail -n 1)
moves_list=($(python3 parse_moves.py "$moves_string"))

# Print metadata
echo "$metadata"

# Initialize variables
move_index=0
moves_history=()
board=()
initialize_board

# Initial display
echo "Move ${move_index}/${#moves_list[@]}"
display_board "${board[@]}"

# Main loop
while true; do
    # Print prompt line
    prompt="Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit:"
    echo "$prompt"

    # Read the user input
    read -p "$prompt " input
    show_board="true"
    
    # Reset the no more moves flag
    no_more_moves="false"

    case $input in
    d)
        if (( move_index < ${#moves_list[@]} )); then
            move="${moves_list[$move_index]}"
            apply_move "$move"
            moves_history+=("$move")
            ((move_index++))
        else
            no_more_moves="true"
            show_board="false"
        fi
        ;;
    a)
        if (( move_index > 0 )); then
            reverse_move "${moves_history[-1]}"
            unset moves_history[-1]
            move_index=${#moves_history[@]}
            for move in "${moves_history[@]}"; do
                apply_move "$move"
            done
        fi
        ;;
    w)
        initialize_board
        moves_history=()
        move_index=0
        ;;
    s)
        initialize_board
        moves_history=()
        move_index=0
        for move in "${moves_list[@]}"; do
            apply_move "$move"
            moves_history+=("$move")
            ((move_index++))
        done
        ;;
    q)
        echo "Exiting."
        echo "End of game."
        exit 0
        ;;
    *)
        echo "Invalid key pressed: $input"
        show_board="false"
        ;;
    esac

    # Display the board if needed
    if [[ $no_more_moves == "true" ]]; then
        echo "No more moves available."
    elif [[ $show_board == "true" ]]; then
        echo "Move ${move_index}/${#moves_list[@]}"
        display_board "${board[@]}"
    fi
done
