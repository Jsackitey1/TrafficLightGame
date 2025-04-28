// =======================
// File: game_board.dart
// =======================

// Pure Dart file (No Flutter)

enum Light { off, green, yellow, red }

class GameBoard {
  final int rows = 3;
  final int cols = 4;
  List<List<Light>> grid;
  bool finished = false;
  int currentPlayer = 1;

  GameBoard() : grid = List.generate(3, (_) => List.filled(4, Light.off));

  bool applyMove(int row, int col) {
    if (finished) return false;
    if (!_isValidMove(row, col)) return false;

    grid[row][col] = _nextLight(grid[row][col]);

    if (_checkWin(row, col)) {
      finished = true;
    } else {
      _switchTurn();
    }

    return true;
  }

  bool _isValidMove(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < cols && grid[row][col] != Light.red;
  }

  Light _nextLight(Light light) {
    switch (light) {
      case Light.off:
        return Light.green;
      case Light.green:
        return Light.yellow;
      case Light.yellow:
        return Light.red;
      case Light.red:
        return Light.red;
    }
  }

  void _switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }

  bool _checkWin(int row, int col) {
    Light color = grid[row][col];
    return _checkRow(row, color) || _checkCol(col, color) || _checkDiagonals(color);
  }

  bool _checkRow(int row, Light color) {
    int count = grid[row].where((cell) => cell == color).length;
    return count >= 3;
  }

  bool _checkCol(int col, Light color) {
    int count = 0;
    for (var row = 0; row < rows; row++) {
      if (grid[row][col] == color) count++;
    }
    return count >= 3;
  }

  bool _checkDiagonals(Light color) {
    List<List<List<int>>> diagonals = [
      [[0, 0], [1, 1], [2, 2]],
      [[0, 1], [1, 2], [2, 3]],
      [[0, 3], [1, 2], [2, 1]],
      [[0, 2], [1, 1], [2, 0]]
    ];

    for (var diag in diagonals) {
      if (diag.every((pos) => grid[pos[0]][pos[1]] == color)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    grid = List.generate(3, (_) => List.filled(4, Light.off));
    finished = false;
    currentPlayer = 1;
  }
}