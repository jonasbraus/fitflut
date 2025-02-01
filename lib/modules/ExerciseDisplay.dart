import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/gymPages/PageGymEditExercise.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:flutter/material.dart';

class ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDisplay({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageGymEditExercise(exercise: exercise),
        ))
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: {
              BodyRegions.arms: DecorationImage(
                  image: AssetImage("assets/arm.jpeg"), fit: BoxFit.cover),
              BodyRegions.stomach: DecorationImage(
                  image: AssetImage("assets/stomach.jpeg"), fit: BoxFit.cover),
              BodyRegions.chest: DecorationImage(
                  image: AssetImage("assets/chest.jpeg"), fit: BoxFit.cover),
              BodyRegions.legs: DecorationImage(
                  image: AssetImage("assets/leg.jpeg"), fit: BoxFit.cover),
              BodyRegions.back: DecorationImage(
                  image: AssetImage("assets/back.jpeg"), fit: BoxFit.cover),
              BodyRegions.fullBody: DecorationImage(
                  image: AssetImage("assets/body.jpeg"), fit: BoxFit.cover),
            }[exercise.bodyRegion]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                exercise.name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.heart_broken_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${exercise.weight} kg",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${exercise.bodyRegion.toString().split('.')[1]}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
