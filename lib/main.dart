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
      title: 'Kindacode.com',
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
  List person = [];
  String number = '';

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/people.json');
    final responseData = await json.decode(response);

    setState(() {
      person = responseData;
    });

    final String numbers = await rootBundle.loadString('assets/numbers.json');
    final numbersData = await json.decode(numbers);
    number = numbersData
        .firstWhere((element) => element['name'] == person[2]['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MAD Assignment 2',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Fetch JSON'),
              onPressed: readJson,
            ),
            // TODO: Add a Text widget that displays the name of the person
            Text(
              person.isEmpty ? '' : person.first['name'],
              style: const TextStyle(fontSize: 25),
            ),

            // TODO: Add a Text widget that displays the number of the person
            Text(
              number.isEmpty ? '' : number,
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}