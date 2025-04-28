// =======================
// File: main.dart
// =======================

import 'package:flutter/material.dart';
import 'game_board.dart';

void main() {
  runApp(TrafficLightsApp());
}

class TrafficLightsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Lights',
      home: TrafficLightsGame(),
    );
  }
}

class TrafficLightsGame extends StatefulWidget {
  @override
  _TrafficLightsGameState createState() => _TrafficLightsGameState();
}

class _TrafficLightsGameState extends State<TrafficLightsGame> {
  GameBoard board = GameBoard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Lights'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            board.finished ? 'Player ${board.currentPlayer == 1 ? 2 : 1} Wins!' : 'Player ${board.currentPlayer}\'s Turn',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                int row = index ~/ 4;
                int col = index % 4;
                Light light = board.grid[row][col];
                return GestureDetector(
                  onTap: () {
                    if (!board.finished && board.grid[row][col] != Light.red) {
                      setState(() {
                        board.applyMove(row, col);
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _lightColor(light),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: _lightIcon(light),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    board.reset();
                  });
                },
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('How to Play'),
                      content: Text(
                          'Tap a light to change it: Off -> Green -> Yellow -> Red.\n\nFirst to make three same-colored lights in a row/column/diagonal wins!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                child: Text('Help'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Color _lightColor(Light light) {
    switch (light) {
      case Light.off:
        return Colors.grey[300]!;
      case Light.green:
        return Colors.green;
      case Light.yellow:
        return Colors.yellow;
      case Light.red:
        return Colors.red;
    }
  }

  Widget _lightIcon(Light light) {
    switch (light) {
      case Light.off:
        return Icon(Icons.circle_outlined, size: 30);
      case Light.green:
        return Icon(Icons.circle, size: 30);
      case Light.yellow:
        return Icon(Icons.change_history, size: 30);
      case Light.red:
        return Icon(Icons.stop, size: 30);
    }
  }
}
