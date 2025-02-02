import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

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

    print(snapshot.data!);

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

  @override
  Widget build(BuildContext context) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return FutureBuilder(
      future: getWorkoutsLast7Days(),
      builder: (context, snapshot) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withAlpha(20), borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Last 7 days activity", style: TextStyle(fontSize: 16),),
                  SizedBox(height: 20),
                  buildWorkoutDays(context, snapshot)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
