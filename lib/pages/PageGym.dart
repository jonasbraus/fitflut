import 'package:fitflut/gymPages/PageGymAddExercise.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/modules/ExerciseDisplay.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageGym extends StatelessWidget {
  const PageGym({super.key});

  Future<List<Exercise>> getExercises() async {
    List<Exercise> output = await DatabaseHelper.getExercises();
    return output;
  }

  List<Widget> buildExerciseChildren(AsyncSnapshot<List<Exercise>> snapshot) {
    if (snapshot.data == null) {
      return [Container()];
    }

    return [
      SizedBox(
        height: 10,
      ),
      for (Exercise exercise in snapshot.data!)
        ExerciseDisplay(exercise: exercise),
      SizedBox(
        height: 10,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseUpdateProvider>(
      builder: (context, value, child) => FutureBuilder(
        future: getExercises(),
        builder: (context, snapshot) => Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                    spacing: 10, children: buildExerciseChildren(snapshot)),
              )),
              FilledButton.icon(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PageGymAddExercise(),
                  ))
                },
                label: Text("Add Exercise"),
                icon: Icon(Icons.add_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }
}
