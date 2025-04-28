import 'package:flutter/material.dart';
import 'dart:math' as math;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // 3x3 grid to store the traffic light states
  // 0 = empty, 1 = red hexagon, 2 = yellow triangle, 3 = green circle
  List<List<int>> grid = List.generate(3, (_) => List.filled(3, 0));
  
  // Track current player (1 for Player 1, 2 for Player 2)
  int currentPlayer = 1;
  
  // Track game state
  bool gameOver = false;
  String? winner;

  // Track number of changes per cell
  List<List<int>> changeCount = List.generate(3, (_) => List.filled(3, 0));

  void _resetGame() {
    setState(() {
      grid = List.generate(3, (_) => List.filled(3, 0));
      changeCount = List.generate(3, (_) => List.filled(3, 0));
      currentPlayer = 1;
      gameOver = false;
      winner = null;
    });
  }

  bool _checkWin(int shape) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (grid[i][0] == shape && grid[i][1] == shape && grid[i][2] == shape) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (grid[0][i] == shape && grid[1][i] == shape && grid[2][i] == shape) {
        return true;
      }
    }

    // Check diagonals
    if (grid[0][0] == shape && grid[1][1] == shape && grid[2][2] == shape) {
      return true;
    }
    if (grid[0][2] == shape && grid[1][1] == shape && grid[2][0] == shape) {
      return true;
    }

    return false;
  }

  void _handleTap(int row, int col) {
    if (gameOver) return;
    if (changeCount[row][col] >= 3) return;

    setState(() {
      // Cycle through states: empty -> red hexagon -> yellow triangle -> green circle
      grid[row][col] = (grid[row][col] + 1) % 4;
      changeCount[row][col]++;
      
      // Check for win based on the current shape
      if (grid[row][col] > 0) {
        if (_checkWin(grid[row][col])) {
          gameOver = true;
          String shapeName = grid[row][col] == 1 ? "Red Hexagon" : 
                           grid[row][col] == 2 ? "Yellow Triangle" : 
                           "Green Circle";
          winner = "Player ${currentPlayer} with $shapeName";
        }
      }
      
      // Switch turns
      currentPlayer = currentPlayer == 1 ? 2 : 1;
    });
  }

  Widget _getShape(int state) {
    switch (state) {
      case 1: // Red hexagon
        return CustomPaint(
          painter: HexagonPainter(color: Colors.red),
          size: const Size(40, 40),
        );
      case 2: // Yellow triangle
        return CustomPaint(
          painter: TrianglePainter(color: Colors.yellow),
          size: const Size(40, 40),
        );
      case 3: // Green circle
        return CustomPaint(
          painter: CirclePainter(color: Colors.green),
          size: const Size(40, 40),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traffic Light Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameOver)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    'Game Over! $winner Wins!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: currentPlayer == 1 ? Colors.red.withOpacity(0.1) : Colors.yellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: currentPlayer == 1 ? Colors.red : Colors.yellow,
                    ),
                  ),
                  child: Text(
                    'Current Player: Player $currentPlayer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: currentPlayer == 1 ? Colors.red : Colors.yellow,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(3, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (col) {
                        return GestureDetector(
                          onTap: () => _handleTap(row, col),
                          child: Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _getShape(grid[row][col]),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Game'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CirclePainter extends CustomPainter {
  final Color color;

  CirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 