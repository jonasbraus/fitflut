import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database database;

  static Future<void> initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "workout_db.db"),
      onCreate: (db, version) {
        return db.execute(
            "create table exercise(id integer primary key, name text, weight int, bodyregion text)");
      },
      version: 1,
    );
  }

  static Future<void> insertExercise(Exercise exercise) async {
    await database.insert("exercise", exercise.toMap());
  }

  static Future<void> updateExercise(Exercise exercise) async {
    await database.update("exercise", exercise.toMap(), where: "id = ?", whereArgs: [exercise.id]);
  }

  static Future<void> deleteExercise(Exercise exercise) async {
    await database.delete("exercise", where: "id = ?", whereArgs: [exercise.id]);
  }

  static Future<List<Exercise>> getExercises() async {
    List<Map<String, Object?>> exerciseMap = await database.query("exercise");
    List<Exercise> exercises = [];


    for (Map<String, Object?> map in exerciseMap) {

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

    return exercises;
  }
}
