// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TargetItem extends StatelessWidget {
  const TargetItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // slide RTL to delete
      // slide LTR to edit
      child: Card(
        color: Colors.cyan[50],
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // CircularPercentIndicator(
            //   radius: 20.0,
            //   lineWidth: 2.0,
            //   percent: 0.5,
            //   progressColor: Colors.red,
            //   backgroundColor: Colors.green,
            // ),
            SizedBox(height: 8.0),
            Text(
              'Target Title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // a row with 2 columns that show the target and current progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Current'),
                    SizedBox(height: 8.0),
                    Text('90'),
                  ],
                ),
                // button to show dialog to edit progress
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.published_with_changes),
                ),
                Column(
                  children: [
                    Text('Target'),
                    SizedBox(height: 8.0),
                    Text('100'),
                  ],
                ),
              ],
            ),
      
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: 0.9,
                  center: Text('90.0%'),
                  progressColor: Colors.greenAccent,
                  barRadius: Radius.circular(50.0)),
            ),
          ],
        ),
      ),
    );
  }
}
