# Chess-Simulator

## PGN File Splitter

### Introduction
The pgn_split.sh script processes chess games recorded in PGN format and splits multiple games contained in a single PGN file into separate files within a specified directory.

### Objectives
- Validate command-line arguments.
- Check if the source PGN file exists.
- Ensure the destination directory exists or create it if necessary.
- Split the source PGN file into individual game files.

### Usage
`./pgn_split.sh <source_pgn_file> <destination_directory>`.

### Example
![image](https://github.com/user-attachments/assets/04a544fe-f50d-4293-a26a-501229ec6996)

## Chess Simulator

### Introduction
The chess_sim.sh script allows you to simulate and navigate through chess games using PGN (Portable Game Notation) files directly from the terminal. By leveraging the parse_moves.py Python script, the Bash script converts PGN chess moves into UCI (Universal Chess Interface) format, making it easier to visualize and manipulate chess games on the command line.

### What is PGN?
Portable Game Notation (PGN) is a standardized format for recording chess games. A PGN file typically contains:
- Metadata: Information about the game, such as the event, location, date, players, and result.
- Moves: The sequence of chess moves written in algebraic notation.
Example PGN snippet:

![image](https://github.com/user-attachments/assets/28af5035-bf39-4a0d-9fad-1d6730e2535d)

### What is UCI?
The Universal Chess Interface (UCI) is a protocol used for communication between chess engines and user interfaces. UCI simplifies the representation of moves, making it easier to process them programmatically. For example, the move e2e4 in UCI represents moving a pawn from e2 to e4.

### Script Functionality
#### Purpose
The chess_sim.sh script provides a way to:
- Parse a chess game from a PGN file.
- Display the game board in the terminal.
- Allow the user to step through the game move by move, jump to the start or end of the game, or quit the simulation.

#### Key Features
 **Interactive Controls**: Navigate through the game using simple key presses:
- 'd': Move forward to the next move.
- 'a': Undo the last move, reverting the board to the previous state.
- 'w': Jump to the start of the game.
- 's': Jump to the end of the game.
- 'q': Quit the simulation.
**Real-time Board Visualization**: The script displays the chessboard in real-time, updating it after each move.
**Metadata Display**: Upon starting the simulation, the script displays key metadata from the PGN file, such as the players' names, event, and result.

  #### Python Integration
The script relies on the parse_moves.py Python script to convert PGN notation into UCI format, which the Bash script then uses to update the board state.

#### Handling Edge Cases
- Start of the Game: If you press 'a' at the start, nothing happens since there are no previous moves to revert.
- End of the Game: If you press 'd' when no more moves are available, the script informs you with a "No more moves available." message.
- Invalid Input: If you press any key other than 'd', 'a', 'w', 's', or 'q', the script will display "Invalid key pressed: <key>".

### Usage
To start the chess simulation, use the following command:
`./chess_sim.sh <pgn_file>`

### Example 
![image](https://github.com/user-attachments/assets/455606ae-8a1d-4d32-9a5b-a204f851a9ee)


  


