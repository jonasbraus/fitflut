import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageGymAddExercise extends StatefulWidget {
  const PageGymAddExercise({super.key});

  @override
  State<PageGymAddExercise> createState() => _PageGymAddExerciseState();
}

class _PageGymAddExerciseState extends State<PageGymAddExercise> {
  int weight = 20;
  BodyRegions bodyRegion = BodyRegions.arms;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Add Exercise"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 5, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                            labelText: "Exercise Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Weight",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "$weight kg",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                      Slider(
                        min: 1,
                        max: 100,
                        divisions: 50,
                        value: weight.toDouble(),
                        onChanged: (value) => setState(() {
                          weight = value.toInt();
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Training Region",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Arms"),
                        groupValue: bodyRegion,
                        value: BodyRegions.arms,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Chest"),
                        groupValue: bodyRegion,
                        value: BodyRegions.chest,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Stomach"),
                        groupValue: bodyRegion,
                        value: BodyRegions.stomach,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Back"),
                        groupValue: bodyRegion,
                        value: BodyRegions.back,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Legs"),
                        groupValue: bodyRegion,
                        value: BodyRegions.legs,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                      RadioListTile<BodyRegions>(
                        title: Text("Whole Body"),
                        groupValue: bodyRegion,
                        value: BodyRegions.fullBody,
                        onChanged: (value) => setState(() {
                          bodyRegion = value!;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: FilledButton.icon(
                onPressed: () async => {
                      await DatabaseHelper.insertExercise(Exercise(
                          id: -1,
                          name: name,
                          weight: weight,
                          bodyRegion: bodyRegion)),
                      Provider.of<ExerciseUpdateProvider>(context,
                              listen: false)
                          .updateState(),
                      Navigator.of(context).pop()
                    },
                icon: Icon(Icons.save_alt),
                label: Text("Save")),
          )
        ],
      ),
    );
  }
}
