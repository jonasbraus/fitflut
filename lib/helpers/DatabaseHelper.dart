import 'dart:io';

import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/helpers/Workout.dart';
import 'package:fitflut/helpers/WorkoutEditChange.dart';
import 'package:fitflut/helpers/WorkoutEditType.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database database;

  static Future<void> _createTableIfNotExists(
      String name, String createSt) async {
    var tableExists = await database.rawQuery(
        "select name from sqlite_master where type='table' and name=?", [name]);

    if (tableExists.isEmpty) {
      await database.execute(createSt);
    }
  }

  static Future<void> initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "workout_db.db"),
      onCreate: (db, version) {
        return db.execute(
            "create table exercise(id integer primary key, name text, weight int, bodyregion text);");
      },
      version: 1,
    );
    _createTableIfNotExists("exercise",
        "create table exercise(id integer primary key, name text, weight int, bodyregion text);");
    _createTableIfNotExists(
        "workout", "create table workout(id integer primary key, name text);");
    _createTableIfNotExists("workoutExercise",
        "create table workoutExercise(id integer primary key, workout_id int, exercise_id int);");
    _createTableIfNotExists("workoutTrack",
        "create table workoutTrack(id integer primary key, duration int, time Text, workout_id int);");
  }

  static Future<void> insertTrack(int duration, DateTime time, int workoutID) async {
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(time);
    await database.insert("workoutTrack", {"duration": duration, "time": formattedDate, "workout_id": workoutID});
  }

  static Future<int> getWorkoutCountByDay(int year, int month, int day) async {
    List<Map<String, Object?>> result = await database.query("workoutTrack");

    print(result);

    int output = 0;
    for (Map<String, Object?> map in result) {
      String timeStamp = map["time"] as String;
      DateTime dt = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(timeStamp);
      if (dt.day == day && dt.year == year && dt.month == month) {
        output += 1;
      }
    }

    print(output);

    return output;
  }

  static Future<void> insertExercise(Exercise exercise) async {
    await database.insert("exercise", exercise.toMap());
  }

  static Future<int> insertWorkout(Workout workout) async {
    await database.insert("workout", {"name": workout.name});

    List<Map<String, Object?>> idList =
        await database.rawQuery("select max(id) from workout");
    int workoutId = idList.first["max(id)"] as int;

    for (Exercise exercise in workout.exercises) {
      await database.insert("workoutExercise",
          {"workout_id": workoutId, "exercise_id": exercise.id});
    }

    return workoutId;
  }

  static Future<List<Workout>> getAllWorkouts() async {
    List<Map<String, Object?>> workoutMap = await database.rawQuery('''
        select workout.id as 'workoutID', workout.name as 'workoutName', exercise.id as 'exerciseID', exercise.name as 'exerciseName', exercise.weight, exercise.bodyregion 
        from workoutExercise
        inner join exercise on exercise.id = workoutExercise.exercise_id
        inner join workout on workout.id = workoutExercise.workout_id
        ''');

    Map<int, Workout> workoutObjects = {};
    for (Map<String, Object?> map in workoutMap) {
      int workoutId = map["workoutID"] as int;
      String workoutName = map["workoutName"] as String;
      int exerciseID = map["exerciseID"] as int;
      String exerciseName = map["exerciseName"] as String;
      int weight = map["weight"] as int;
      BodyRegions bodyRegion = {
        "BodyRegions.arms": BodyRegions.arms,
        "BodyRegions.stomach": BodyRegions.stomach,
        "BodyRegions.chest": BodyRegions.chest,
        "BodyRegions.fullBody": BodyRegions.fullBody,
        "BodyRegions.legs": BodyRegions.legs,
        "BodyRegions.back": BodyRegions.back
      }[map["bodyregion"]]!;

      if (!workoutObjects.keys.contains(workoutId)) {
        workoutObjects[workoutId] =
            Workout(id: workoutId, name: workoutName, exercises: []);
      }

      workoutObjects[workoutId]!.exercises.add(Exercise(
          id: exerciseID,
          name: exerciseName,
          weight: weight,
          bodyRegion: bodyRegion));
    }

    List<Workout> result = [];

    for (int key in workoutObjects.keys) {
      result.add(workoutObjects[key]!);
    }

    return result;
  }

  static Future<void> deleteWorkout(Workout workout) async {
    await database.delete("workout", where: "id = ?", whereArgs: [workout.id]);
    await database.delete("workoutExercise",
        where: "workout_id = ?", whereArgs: [workout.id]);
    await database.delete("workoutTrack", where: "workout_id = ?", whereArgs: [workout.id]);
  }

  static Future<void> updateWorkout(
      Workout workout, List<WorkoutEditChange> changes) async {
    await database.update("workout", workout.toMap(),
        where: "id = ?", whereArgs: [workout.id]);

    for (WorkoutEditChange change in changes) {
      if (change.type == WorkoutEditType.delete) {
        await database.delete("workoutExercise",
            where: "workout_id = ? and exercise_id = ?",
            whereArgs: [change.workoutId, change.exerciseId]);
      } else {
        await database.insert("workoutExercise",
            {"workout_id": change.workoutId, "exercise_id": change.exerciseId});
      }
    }
  }

  static Future<void> updateExercise(Exercise exercise) async {
    await database.update("exercise", exercise.toMap(),
        where: "id = ?", whereArgs: [exercise.id]);
  }

  static Future<void> deleteExercise(Exercise exercise) async {
    await database
        .delete("exercise", where: "id = ?", whereArgs: [exercise.id]);
    await database.delete("workoutExercise",
        where: "exercise_id = ?", whereArgs: [exercise.id]);
  }

  static Future<List<Exercise>> getExercises(String filter) async {
    List<Map<String, Object?>> exerciseMap = await database.query("exercise");
    List<Exercise> exercises = [];

    for (Map<String, Object?> map in exerciseMap) {
      if ((map["bodyregion"] as String).split(".")[1] == filter ||
          filter == "") {
        exercises.add(Exercise(
          id: map["id"] as int,
          name: map["name"] as String,
          weight: map["weight"] as int,
          bodyRegion: {
            "BodyRegions.arms": BodyRegions.arms,
            "BodyRegions.stomach": BodyRegions.stomach,
            "BodyRegions.chest": BodyRegions.chest,
            "BodyRegions.fullBody": BodyRegions.fullBody,
            "BodyRegions.legs": BodyRegions.legs,
            "BodyRegions.back": BodyRegions.back
          }[map["bodyregion"]]!,
        ));
      }
    }

    return exercises;
  }
}
