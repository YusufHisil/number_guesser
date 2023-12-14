import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Guesser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NumberGuessPage(),
    );
  }
}

class NumberGuessPage extends StatefulWidget {
  const NumberGuessPage({super.key});

  @override
  _NumberGuessPageState createState() => _NumberGuessPageState();
}

class _NumberGuessPageState extends State<NumberGuessPage> {
  int _targetNumber = 0;
  String _guess = '';
  String _feedbackText = '';
  bool _hasGuessedCorrectly = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _targetNumber = Random().nextInt(100) + 1;
  }

  void _handleGuess() {
    setState(() {
      int? guess = int.tryParse(_guess);
      if (guess != null) {
        if (guess < _targetNumber) {
          _feedbackText = 'Try higher';
        } else if (guess > _targetNumber) {
          _feedbackText = 'Try lower';
        } else {
          _feedbackText = 'You guessed right. It was $_targetNumber';
          _hasGuessedCorrectly = true;
          _showDialog();
        }
      }
    });
  }

  void _resetGame() {
    setState(() {
      _targetNumber = Random().nextInt(100) + 1;
      _feedbackText = '';
      _hasGuessedCorrectly = false;
      _controller.clear();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: Text(_feedbackText),
          actions: <Widget>[
            TextButton(
              child: const Text("Try again!"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess my number', textAlign: TextAlign.center),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'I\'m thinking of a number between 1 and 100',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Text(
            'It\'s your turn to guess my number!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              (_guess.isEmpty) ? '' : "You tried $_guess\n$_feedbackText",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Try a number!',
                  style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                ),
                TextField(
                  controller: _controller,
                  enabled: !_hasGuessedCorrectly,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter your guess here',
                  ),
                  onChanged: (value) => _guess = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _hasGuessedCorrectly ? _resetGame : _handleGuess,
                  child: Text(_hasGuessedCorrectly ? 'Reset' : 'Guess'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
