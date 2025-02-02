import 'package:fitflut/helpers/Workout.dart';
import 'package:fitflut/helpers/WorkoutEditChange.dart';
import 'package:fitflut/helpers/WorkoutEditType.dart';
import 'package:fitflut/providers/WorkoutUpdateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/DatabaseHelper.dart';
import '../helpers/Exercise.dart';

class PageWorkoutEdit extends StatefulWidget {
  final Workout workout;

  const PageWorkoutEdit({super.key, required this.workout});

  @override
  State<PageWorkoutEdit> createState() => _PageWorkoutEditState();
}

class _PageWorkoutEditState extends State<PageWorkoutEdit> {
  Future<List<Exercise>> getExercises(String filter) async {
    List<Exercise> output = await DatabaseHelper.getExercises(filter);
    output.sort((a, b) => a.bodyRegion.index.compareTo(b.bodyRegion.index));
    return output;
  }

  String name = "";
  List<Exercise> exercises = [];
  List<WorkoutEditChange> changes = [];

  @override
  void initState() {
    name = widget.workout.name;
    exercises = widget.workout.exercises;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Edit Workout"),
      ),
      body: FutureBuilder(
        future: getExercises(""),
        builder: (context, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 20, bottom: 5, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: name,
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(
                              labelText: "Workout Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: FilledButton.icon(
                            onPressed: () => {
                              showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  titlePadding: EdgeInsets.all(15),
                                  contentPadding: EdgeInsets.all(15),
                                  insetPadding: EdgeInsets.zero,
                                  children: [
                                    Column(
                                      children: [
                                        for (Exercise exercise in snapshot.data!)
                                          GestureDetector(
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: AssetImage("assets/body.jpeg"), fit: BoxFit.cover),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  exercise.name,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 5)
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            onTap: () => setState(() {
                                              changes.add(WorkoutEditChange(
                                                  workoutId: widget.workout.id,
                                                  exerciseId: exercise.id,
                                                  type: WorkoutEditType.create));
                                              exercises.add(exercise);
                                              Navigator.pop(context);
                                            }),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            },
                            label: Text("Add Exercise"),
                            icon: Icon(Icons.add),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        for (Exercise exercise in exercises)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                    image: AssetImage("assets/body.jpeg"), fit: BoxFit.cover)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      changes.add(WorkoutEditChange(workoutId: widget.workout.id, exerciseId: exercise.id, type: WorkoutEditType.delete));
                                      exercises.remove(exercise);
                                    })
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  exercise.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black, blurRadius: 5)
                                      ]),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () async => {
                        await DatabaseHelper.deleteWorkout(widget.workout),
                        Provider.of<WorkoutUpdateProvider>(context,
                                listen: false)
                            .updateState(),
                        Navigator.of(context).pop()
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async => {
                        await DatabaseHelper.updateWorkout(Workout(id: widget.workout.id, name: name, exercises: []), changes),
                        Provider.of<WorkoutUpdateProvider>(context, listen: false).updateState(),
                        Navigator.of(context).pop()
                      },
                      icon: Icon(Icons.save_alt),
                      label: Text("Save"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
