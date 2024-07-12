import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/Pages/habit_tiles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//overall habit list
  List habitList = [
//[habitname, habitstarted, timespend, goaltime]
    ['Sport', false, 0, 1],
    ['Read', false, 0, 20],
    ['meditate', false, 0, 42],
    ['code', false, 0, 32],
    ['sleep', false, 0, 22],
  ];

  void habitStarted(int index) {
    //noting what start time is
    var startTime = DateTime.now();

    //including the already elapsed time
    int elapsedTime = habitList[index][2];

    //habite started or stoped
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1] == true) {
      //manage time
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //calculating time elapes by comparing current time with start time
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime + currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);

          //checking when user has stoped the time
          if (!habitList[index][1]) {
            timer.cancel();
          }
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('settings of ' + habitList[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text(
          'Building new habits is the key',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: ((context, index) {
          return HabitTiles(
            habitName: habitList[index][0],
            onTap: () {
              habitStarted(index);
            },
            settingsTapped: () {
              settingsOpened(index);
            },
            habitStarted: habitList[index][1],
            timeSpend: habitList[index][2],
            goalTime: habitList[index][3],
          );
        }),
      ),
    );
  }
}
