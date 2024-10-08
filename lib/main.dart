import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number to Words',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NumberToWordsScreen(),
    );
  }
}

class NumberToWordsScreen extends StatefulWidget {
  @override
  _NumberToWordsScreenState createState() => _NumberToWordsScreenState();
}

class _NumberToWordsScreenState extends State<NumberToWordsScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _convertedText = '';

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _convertToArabic() {
    final number = _numberController.text;

    if (number.isNotEmpty) {
      final double intNumber = double.parse(number);
      final int dinar = intNumber.toInt();
      final int milli = ((intNumber - dinar) * 1000).round();

      setState(() {
        String dinarText = Tafqeet.convert(dinar.toString());
        String milliText = milli > 0 ? Tafqeet.convert(milli.toString()) : '';

        if (milli > 0) {
          _convertedText = '$dinarText دينار و $milliText مليم';
        } else {
          _convertedText = '$dinarText دينار';
        }
      });
    } else {
      setState(() {
        _convertedText = 'Please enter a number';
      });
    }
  }

  void _convertToEnglish() {
    final number = double.tryParse(_numberController.text);

    if (number != null) {
      final integerPart = number.toInt();
      final fractionPart = ((number - integerPart) * 100).round();

      setState(() {
        if (fractionPart > 0) {
          _convertedText =
              '${_numberToWordsEnglish(integerPart)} dollars and ${_numberToWordsEnglish(fractionPart)} cents';
        } else {
          _convertedText = '${_numberToWordsEnglish(integerPart)} dollars';
        }
      });
    } else {
      setState(() {
        _convertedText = 'Invalid input';
      });
    }
  }

  String _numberToWordsEnglish(int number) {
    final units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen'
    ];
    final tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];

    if (number < 20) return units[number];
    if (number < 100) {
      return '${tens[number ~/ 10]} ${units[number % 10]}'.trim();
    }
    if (number < 1000) {
      return '${units[number ~/ 100]} hundred ${_numberToWordsEnglish(number % 100)}'
          .trim();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number to Words'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Text(
                'Workshop 2',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _convertToArabic,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Convert to Arabic'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _convertToEnglish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Convert to English'),
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _convertedText,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
