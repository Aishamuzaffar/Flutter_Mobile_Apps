import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(
        toggleTheme: () {
          setState(() {
            _themeMode =
                _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final Function toggleTheme;

  CalculatorPage({required this.toggleTheme});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = '0';
  String _expression = '';

  void _onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      _output = '0';
      _expression = '';
    } else if (buttonText == '=') {
      try {
        Parser p = Parser();
        Expression exp = p.parse(_expression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        _output = eval.toString();
        _expression = '';
      } catch (e) {
        _output = 'Error';
      }
    } else {
      _expression += buttonText;
      _output = _expression;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.blueGrey
        : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CALCULATOR',
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
            wordSpacing: 2.0,
            height: 12.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48.0,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add some spacing
            // Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  // Row 1
                  _buildButton('7', buttonColor),
                  _buildButton('8', buttonColor),
                  _buildButton('9', buttonColor),
                  _buildButton('/', buttonColor),
                  // Row 2
                  _buildButton('4', buttonColor),
                  _buildButton('5', buttonColor),
                  _buildButton('6', buttonColor),
                  _buildButton('*', buttonColor),
                  // Row 3
                  _buildButton('1', buttonColor),
                  _buildButton('2', buttonColor),
                  _buildButton('3', buttonColor),
                  _buildButton('-', buttonColor),
                  // Row 4
                  _buildButton('C', Colors.red),
                  _buildButton('0', buttonColor),
                  _buildButton('=', Colors.green),
                  _buildButton('+', buttonColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText, Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(5.0),
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
      ),
    );
  }
}
