import 'package:fitflut/providers/GymgoalProvider.dart';
import 'package:fitflut/workoutPages/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/LanguageProvider.dart';
import '../providers/PageProvider.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  void storeColorScheme(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("color", id);
  }

  void storeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lang", lang);
  }

  void storeGymgoal(int days) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("gymgoal", days);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: Consumer<LanguageProvider>(
        builder: (context, provLang, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(LanguageProvider.getMap()["settings"]["language"],
                style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () =>
                  {provLang.updateLang("en"), storeLanguage("en")},
                  child: Text("en"),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        LanguageProvider.lang == "en"
                            ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100)
                            : Theme.of(context).colorScheme.primary),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FilledButton(
                  onPressed: () => {
                    provLang.updateLang("de"),
                    storeLanguage("de"),
                  },
                  child: Text("de"),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        LanguageProvider.lang == "de"
                            ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100)
                            : Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(LanguageProvider.getMap()["settings"]["gymgoal"],
                style: TextStyle(fontSize: 17)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<GymgoalProvider>(
                  builder: (context, goalProv, child) => Row(
                    children: [
                      Slider(
                        value: GymgoalProvider.goal.toDouble(),
                        onChanged: (value) => {
                          goalProv.setGoal(
                            value.toInt(),
                          ),
                          storeGymgoal(value.toInt())
                        },
                        divisions: 7,
                        min: 0,
                        max: 7,
                      ),
                      SizedBox(width: 10),
                      Text(
                        GymgoalProvider.goal.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
