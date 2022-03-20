import 'package:flutter/material.dart';
import 'stopWatch.dart';
void main() => runApp(StopwatchApp());
class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopWatch(),
    ); }
}
