import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  @override
  late int seconds;
  late Timer timer;
  bool isTicking = true;
  List<String> laps = [];

  @override
  void initState() {
    super.initState();
    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salman Inayat - 263202'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$seconds ${_secondsText()}',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Start'),
                onPressed: isTicking ? null : _startTimer,
              ),
              SizedBox(width: 20),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Stop'),
                onPressed: isTicking ? _stopTimer : null,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Reset'),
                onPressed: isTicking ? null : _restartTimer,
              ),
              SizedBox(width: 20),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 27, 25, 126)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Lap'),
                onPressed: _storeLaps,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Text('Lap ${index + 1}'),
                      SizedBox(width: 20),
                      Text('Time: ${laps[index]}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _secondsText() => seconds == 1 ? 'second' : 'seconds';

  void _onTick(Timer time) {
    setState(() {
      ++seconds;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {
      isTicking = true;
    });
  }

  void _restartTimer() {
    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {
      isTicking = true;
    });
  }

  void _stopTimer() {
    timer.cancel();
    setState(() {
      isTicking = false;
    });
  }

  void _storeLaps() async {
    var data = json.encode({
      "number": laps.length + 1,
      "seconds": seconds,
    });

    laps.add(data);

    final file = await _localFile;

    final contents = await file.readAsString();

    print(contents);

    // Add the new data
    final lapData = json.encode({
      'seconds': seconds,
      'number': laps.length + 1,
    });

    // Write the file
    file.writeAsStringSync(contents + lapData);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/laps.json');
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
