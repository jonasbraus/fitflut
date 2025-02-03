import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/LanguageProvider.dart';

class PageGymEditExercise extends StatefulWidget {
  final Exercise exercise;

  const PageGymEditExercise({super.key, required this.exercise});

  @override
  State<PageGymEditExercise> createState() => _PageGymEditExerciseState();
}

class _PageGymEditExerciseState extends State<PageGymEditExercise> {
  int weight = 20;
  BodyRegions bodyRegion = BodyRegions.arms;
  String name = "";

  @override
  void initState() {
    name = widget.exercise.name;
    bodyRegion = widget.exercise.bodyRegion;
    weight = widget.exercise.weight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(LanguageProvider.getMap()["exercises"]["editexercise"]),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
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
                              labelText: LanguageProvider.getMap()["exercises"]
                                  ["exercisename"],
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
                              LanguageProvider.getMap()["exercises"]["weight"],
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
                            LanguageProvider.getMap()["exercises"]
                                ["trainingregion"],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(
                              LanguageProvider.getMap()["exercises"]["arms"]),
                          groupValue: bodyRegion,
                          value: BodyRegions.arms,
                          onChanged: (value) => setState(() {
                            bodyRegion = value!;
                          }),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(
                              LanguageProvider.getMap()["exercises"]["chest"]),
                          groupValue: bodyRegion,
                          value: BodyRegions.chest,
                          onChanged: (value) => setState(() {
                            bodyRegion = value!;
                          }),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(LanguageProvider.getMap()["exercises"]
                              ["stomach"]),
                          groupValue: bodyRegion,
                          value: BodyRegions.stomach,
                          onChanged: (value) => setState(() {
                            bodyRegion = value!;
                          }),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(
                              LanguageProvider.getMap()["exercises"]["back"]),
                          groupValue: bodyRegion,
                          value: BodyRegions.back,
                          onChanged: (value) => setState(() {
                            bodyRegion = value!;
                          }),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(
                              LanguageProvider.getMap()["exercises"]["legs"]),
                          groupValue: bodyRegion,
                          value: BodyRegions.legs,
                          onChanged: (value) => setState(() {
                            bodyRegion = value!;
                          }),
                        ),
                        RadioListTile<BodyRegions>(
                          title: Text(LanguageProvider.getMap()["exercises"]
                              ["fullbody"]),
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
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withAlpha(25),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: FilledButton.tonalIcon(
                  onPressed: () async => {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.only(top: 18, left: 18),
                        actionsPadding: EdgeInsets.all(10),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        insetPadding: EdgeInsets.all(0),
                        content: Text(
                          LanguageProvider.getMap()["general"]["sure"],
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton.icon(
                            onPressed: () async => {
                              await DatabaseHelper.deleteExercise(Exercise(
                                  id: widget.exercise.id,
                                  name: name,
                                  weight: weight,
                                  bodyRegion: bodyRegion)),
                              Provider.of<ExerciseUpdateProvider>(context,
                                      listen: false)
                                  .updateState(),
                              Navigator.of(context).pop(),
                              Navigator.of(context).pop()
                            },
                            label: Text(
                                LanguageProvider.getMap()["general"]["delete"], style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onSurface,),
                          ),
                          TextButton.icon(
                            onPressed: () => {Navigator.pop(context)},
                            label: Text(
                                LanguageProvider.getMap()["general"]["cancel"]),
                            icon: Icon(Icons.arrow_back),
                          )
                        ],
                      ),
                    )
                  },
                  icon: Icon(Icons.delete),
                  label: Text(LanguageProvider.getMap()["general"]["delete"]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FilledButton.icon(
                  onPressed: () async => {
                    await DatabaseHelper.updateExercise(Exercise(
                        id: widget.exercise.id,
                        name: name,
                        weight: weight,
                        bodyRegion: bodyRegion)),
                    Provider.of<ExerciseUpdateProvider>(context, listen: false)
                        .updateState(),
                    Navigator.of(context).pop()
                  },
                  icon: Icon(Icons.save_alt),
                  label: Text(LanguageProvider.getMap()["general"]["save"]),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
