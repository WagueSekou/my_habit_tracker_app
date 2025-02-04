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
    //checking if habit has already reached the goal time
    if (habitList[index][2] >= habitList[index][3] * 60) {
      //resetting the time when play is pressed again
      habitList[index][2] = 0;
    }

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
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);

          //checking when user has stoped the time
          //or when goal is reached
          if (!habitList[index][1] ||
              habitList[index][2] >= habitList[index][3] * 60) {
            timer.cancel();
            //if the goal time is reached , stop the habit without resetting the time spent
            if (habitList[index][2] >= habitList[index][3] * 60) {
              habitList[index][1] = false;
            }
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
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Building new habits is the key',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple[250],
                ),
                child: Text(
                  'Habites',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: (){},
              ),

              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: (){},
              ),
            ],
          ),
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
