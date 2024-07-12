import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTiles extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpend;
  final int goalTime;
  final bool habitStarted;

  const HabitTiles({
    Key? key,
    required this.habitName,
    required this.onTap,
    required this.settingsTapped,
    required this.timeSpend,
    required this.goalTime,
    required this.habitStarted,
  }) : super(key: key);

//coverting time spend into min:sec ->exple 62sec = 1:02sec
  String minsecFormat(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    //if secs is a 1 digit number, place a 0 infront of it
    if (secs.length == 1) {
      secs = '0' + secs;
    }

    //resolving the decimalplace pb if min is a 1 digit number
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return mins + '.' + secs;
  }

  //calculating the progress in percentage
  double percentCompleted() {
    return timeSpend / (goalTime * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          //circular progress indicator
                          CircularPercentIndicator(
                            radius: 30,
                            percent: 
                              percentCompleted() < 1 ? percentCompleted() : 1,
                            progressColor: percentCompleted() > 0.5 
                            ? (percentCompleted() > 0.75 ?Colors.blue : Colors.green) : (percentCompleted() > 0.25 ?Colors.yellow : Colors.red),
                          ),

                          //play and pause button
                          Center(
                            child: Icon(
                                habitStarted ? Icons.pause : Icons.play_arrow),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //habite name
                      Text(
                        habitName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      //progress
                      Text(
                        minsecFormat(timeSpend) + '/' + goalTime.toString() 
                        + ' = ' + (percentCompleted()*100).toStringAsFixed(0) + '%',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: settingsTapped,
                child: Icon(Icons.settings),
              ),
            ],
          ),
        ));
  }
}
