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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: Row(
        children: [
          Consumer<LanguageProvider>(
            builder: (context, provLang, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageProvider.getMap()["settings"]["colorscheme"],
                  style: TextStyle(fontSize: 18),
                ),
                Consumer<SettingsProvider>(
                  builder: (context, prov, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<int>(
                        onChanged: (value) =>
                            {prov.selectColor(0), storeColorScheme(0)},
                        value: 0,
                        groupValue: SettingsProvider.selectedColor,
                        fillColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      Radio<int>(
                        onChanged: (value) =>
                            {prov.selectColor(1), storeColorScheme(1)},
                        value: 1,
                        groupValue: SettingsProvider.selectedColor,
                        fillColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      Radio<int>(
                        onChanged: (value) =>
                            {prov.selectColor(2), storeColorScheme(2)},
                        value: 2,
                        groupValue: SettingsProvider.selectedColor,
                        fillColor: WidgetStatePropertyAll(Colors.purple),
                      ),
                      Radio<int>(
                        onChanged: (value) =>
                            {prov.selectColor(3), storeColorScheme(3)},
                        value: 3,
                        groupValue: SettingsProvider.selectedColor,
                        fillColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      Radio<int>(
                        onChanged: (value) =>
                            {prov.selectColor(4), storeColorScheme(4)},
                        value: 4,
                        groupValue: SettingsProvider.selectedColor,
                        fillColor: WidgetStatePropertyAll(Colors.orange),
                      )
                    ],
                  ),
                ),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
