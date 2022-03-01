import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'MAD Assignment 02',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _dialId = 0;
  List persons = [];
  List numbers = [];
  String _name = '';
  // ignore: avoid_init_to_null
  var _number = null;

  Future<void> fetchNumber() async {
    final String response = await rootBundle.loadString('assets/people.json');
    final responseData = await json.decode(response);

    setState(() {
      persons = responseData['people'];
      _name = responseData['people'][_dialId]['name'];
    });

    final String numbersResponse =
        await rootBundle.loadString('assets/numbers.json');
    final numbersData = await json.decode(numbersResponse);

    setState(() {
      numbers = numbersData['numbers'];
    });

    var number = numbers.firstWhere((element) => element['name'] == _name);
    setState(() {
      _number = number['phoneNo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Salman Inayat - 263202'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter dialpad id',
              ),
              onChanged: (value) {
                setState(() {
                  if (value != ''){
                    _dialId = int.parse(value);
                  }
                });
              },
            ),
            ElevatedButton(
              child: const Text('Fetch user data'),
              onPressed: fetchNumber,
            ),
            Text(
              _name != null && _name != '' ? _name : '',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              _number != null && _number != 0 ? _number.toString() : '',
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
