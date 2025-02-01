import 'package:fitflut/pages/PageCalories.dart';
import 'package:fitflut/pages/PageGym.dart';
import 'package:fitflut/pages/PageHome.dart';
import 'package:fitflut/pages/PageSettings.dart';
import 'package:fitflut/pages/PageWorkout.dart';
import 'package:flutter/cupertino.dart';

class PageProvider extends ChangeNotifier {
  int selectedPage = 0;
  List<String> titles = ["Home", "Exercises", "Workouts", "Calories", "Settings"];
  List<Widget> pages = [PageHome(), PageGym(), PageWorkout(), PageCalories(), PageSettings()];

  String getSelectedTitle() {
    return titles[selectedPage];
  }

  Widget getPage() {
    return pages[selectedPage];
  }

  void changePage(int index) {
    selectedPage = index;
    notifyListeners();
  }
}