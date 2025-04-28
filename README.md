# Traffic Light Game

A Flutter implementation of a traffic light game where players take turns placing and changing shapes on a 3x3 grid.

## Game Overview

The game is played on a 3x3 grid where players take turns changing the state of cells. Each cell can be changed up to 3 times, cycling through different shapes:

1. Red Hexagon
2. Yellow Triangle
3. Green Circle

## Core Components

### 1. Game State Management

```dart
List<List<int>> grid = List.generate(3, (_) => List.filled(3, 0));
int currentPlayer = 1;
bool gameOver = false;
String? winner;
List<List<int>> changeCount = List.generate(3, (_) => List.filled(3, 0));
```

- `grid`: 3x3 matrix storing the state of each cell (0 = empty, 1 = hexagon, 2 = triangle, 3 = circle)
- `currentPlayer`: Tracks whose turn it is (1 or 2)
- `gameOver`: Boolean flag indicating if the game has ended
- `winner`: Stores the winning player's information
- `changeCount`: Tracks how many times each cell has been changed

### 2. Key Functions

#### Reset Game

```dart
void _resetGame() {
  setState(() {
    grid = List.generate(3, (_) => List.filled(3, 0));
    changeCount = List.generate(3, (_) => List.filled(3, 0));
    currentPlayer = 1;
    gameOver = false;
    winner = null;
  });
}
```

- Resets all game state variables to their initial values
- Clears the grid and change counts
- Resets the current player to Player 1

#### Win Condition Check

```dart
bool _checkWin(int shape) {
  // Check rows
  for (int i = 0; i < 3; i++) {
    if (grid[i][0] == shape && grid[i][1] == shape && grid[i][2] == shape) {
      return true;
    }
  }
  // Check columns and diagonals...
}
```

- Checks for three matching shapes in a row, column, or diagonal
- Returns true if a win condition is met

#### Cell Tap Handler

```dart
void _handleTap(int row, int col) {
  if (gameOver) return;
  if (changeCount[row][col] >= 3) return;

  setState(() {
    grid[row][col] = (grid[row][col] + 1) % 4;
    changeCount[row][col]++;

    if (grid[row][col] > 0) {
      if (_checkWin(grid[row][col])) {
        gameOver = true;
        String shapeName = grid[row][col] == 1 ? "Red Hexagon" :
                         grid[row][col] == 2 ? "Yellow Triangle" :
                         "Green Circle";
        winner = "Player ${currentPlayer} with $shapeName";
      }
    }

    currentPlayer = currentPlayer == 1 ? 2 : 1;
  });

  _controller.forward(from: 0.0);
}
```

- Handles player interactions with cells
- Cycles through shapes (empty → hexagon → triangle → circle)
- Checks for win conditions after each move
- Switches turns between players
- Triggers shape placement animation

### 4. Custom Shape Painters

#### Hexagon Painter

```dart
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draws a hexagon shape
  }
}
```

- Custom painter for drawing red hexagons
- Uses mathematical calculations to create a six-sided shape

#### Triangle Painter

```dart
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draws a triangle shape
  }
}
```

- Custom painter for drawing yellow triangles
- Creates a triangular path with three points

#### Circle Painter

```dart
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draws a circle shape
  }
}
```

- Custom painter for drawing green circles
- Uses the canvas circle drawing method

## UI Components

### 1. Game Board

- 3x3 grid of clickable containers
- Each cell has a light grey background
- Cells show shapes when placed
- Visual feedback for current player's turn

### 2. Player Turn Indicator

- Shows current player number
- Color-coded based on current player
- Updates after each move

### 3. Win Message

- Displays when a player wins
- Shows winning player and shape
- Green-themed container

### 4. Reset Button

- Allows starting a new game
- Resets all game state
- Includes refresh icon

## Game Rules

1. Players take turns changing cell states
2. Each cell can be changed up to 3 times
3. Shapes cycle in order: empty → hexagon → triangle → circle
4. First player to get three of the same shape in a row, column, or diagonal wins
5. Game ends when a win condition is met

## Technical Implementation

- Built using Flutter framework
- Uses custom painting for shapes
- Implements state management for game logic
- Includes animations for better user experience
- Responsive design that works on different screen sizes
