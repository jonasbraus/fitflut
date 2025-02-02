import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/providers/LanguageProvider.dart';
import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  String calcTimeFormat(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    return "$minutes min $seconds sec";
  }

  String formatTime(DateTime time) {
    String day = time.day.toString().length == 1 ? "0${time.day}" : "${time.day}";
    String month = time.month.toString().length == 1 ? "0${time.month}" : "${time.month}";
    String hour = time.hour.toString().length == 1 ? "0${time.hour}" : "${time.hour}";
    String minute = time.minute.toString().length == 1 ? "0${time.minute}" : "${time.minute}";
    return "$day.$month $hour:$minute";
  }
  
  Future<List<int>> getWorkoutsLast7Days() async {
    DateTime now = DateTime.now();

    List<int> output = [];

    for (int i = 0; i < 7; i++) {
      DateTime current = now.subtract(Duration(days: i));
      output.add(await DatabaseHelper.getWorkoutCountByDay(
          current.year, current.month, current.day));
    }

    return output;
  }

  Widget buildWorkoutDays(
      BuildContext context, AsyncSnapshot<List<int>> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    DateTime now = DateTime.now();

    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = snapshot.data!.length - 1; i >= 0; i--)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: (snapshot.data![i]).toDouble() * 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(width: 10)
                ],
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = snapshot.data!.length - 1; i >= 0; i--)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weekdays[now.subtract(Duration(days: i)).weekday - 1]),
                  SizedBox(width: 10)
                ],
              )
          ],
        )
      ],
    );
  }

  Widget buildLastWorkoutDisplay(
      BuildContext context, AsyncSnapshot<Map<String, Object?>> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    DateTime dt = snapshot.data!["time"] as DateTime;
    int duration = snapshot.data!["duration"] as int;
    String name = snapshot.data!["name"] as String;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/gym3.jpeg"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(calcTimeFormat(duration))
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 5),
                Text(formatTime(dt))
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.getLastWorkout();
    return FutureBuilder(
      future: getWorkoutsLast7Days(),
      builder: (context, snapshot) => FutureBuilder(
        future: DatabaseHelper.getLastWorkout(),
        builder: (context, snapshot2) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Text(
                LanguageProvider.getMap()["home"]["welcome"],
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color:
                    Theme.of(context).colorScheme.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LanguageProvider.getMap()["home"]["last7dayactivity"],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    buildWorkoutDays(context, snapshot)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color:
                    Theme.of(context).colorScheme.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LanguageProvider.getMap()["home"]["lastworkout"],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    buildLastWorkoutDisplay(context, snapshot2)
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
