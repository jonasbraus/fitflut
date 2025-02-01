import 'package:fitflut/gymPages/BodyRegions.dart';

class Exercise {
  int id;
  String name;
  int weight;
  BodyRegions bodyRegion;

  Exercise(
      {required this.id, required this.name, required this.weight, required this.bodyRegion});

  Map<String, Object?> toMap() {
    return {
      "name": name,
      "weight": weight,
      "bodyregion": bodyRegion.toString()
    };
  }
}
