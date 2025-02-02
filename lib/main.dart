import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:fitflut/providers/GymPageFilterProvider.dart';
import 'package:fitflut/providers/PageProvider.dart';
import 'package:fitflut/providers/RunningWorkoutProvider.dart';
import 'package:fitflut/providers/WorkoutPageProvider.dart';
import 'package:fitflut/providers/WorkoutUpdateProvider.dart';
import 'package:fitflut/workoutPages/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initDb();
  SettingsProvider.selectedColor = await getColor();
  print(SettingsProvider.selectedColor);

  runApp(const MyApp());
}

Future<int> getColor() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt("color") ?? 0;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GymPageFilterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutPageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RunningWorkoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
      ],
      child: Consumer<SettingsProvider>(builder: (context, prov, child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: prov.getColor()),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: prov.getColor(), brightness: Brightness.dark),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHome(),
      ),),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        child: GNav(
          tabs: [
            GButton(
              icon: Icons.home_rounded,
            ),
            GButton(
              icon: Icons.heart_broken_rounded,
            ),
            GButton(
              icon: Icons.fitness_center_outlined,
            ),
            GButton(
              icon: Icons.settings,
            )
          ],
          iconSize: 22,
          style: GnavStyle.google,
          backgroundColor: Colors.transparent,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.all(15),
          duration: Duration(seconds: 0),
          onTabChange: (value) =>
              Provider.of<PageProvider>(context, listen: false)
                  .changePage(value),
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        actions: [
          Consumer<PageProvider>(
            builder: (context, value, child) => {
              0: Container(),
              1: Padding(
                padding: EdgeInsets.only(left: 0, right: 15, bottom: 0, top: 0),
                child: Consumer<GymPageFilterProvider>(
                  builder: (context, value, child) => DropdownButton<String>(
                    value: value.filter,
                    hint: Text("Filter"),
                    icon: Icon(Icons.sort),
                    items: [
                      DropdownMenuItem<String>(
                        value: "",
                        child: Text("All"),
                      ),
                      DropdownMenuItem<String>(
                        value: "arms",
                        child: Text("Arms"),
                      ),
                      DropdownMenuItem<String>(
                        value: "chest",
                        child: Text("Chest"),
                      ),
                      DropdownMenuItem<String>(
                        value: "stomach",
                        child: Text("Stomach"),
                      ),
                      DropdownMenuItem<String>(
                        value: "back",
                        child: Text("Back"),
                      ),
                      DropdownMenuItem<String>(
                        value: "legs",
                        child: Text("Legs"),
                      ),
                      DropdownMenuItem<String>(
                        value: "fullBody",
                        child: Text("Whole Body"),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      value.setFilter(newValue!);
                    },
                  ),
                ),
              ),
              2: Container(),
              3: Container(),
              4: Container(),
            }[value.selectedPage]!,
          ),
          Consumer<PageProvider>(
            builder: (context, value, child) => {
              0: Container(),
              1: IconButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.all(15),
                      actionsPadding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text("Help"),
                      titlePadding: EdgeInsets.all(15),
                      content: Text(
                        "hold exercise to edit or delete",
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          },
                          child: Text("OK"),
                        )
                      ],
                    ),
                  )
                },
                icon: Icon(Icons.info),
              ),
              2: IconButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.all(15),
                      actionsPadding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text("Help"),
                      titlePadding: EdgeInsets.all(15),
                      content: Text(
                        "tap workout to start \n\nhold workout to edit\n\ncreate exercises before you create your first workout",
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          },
                          child: Text("OK"),
                        )
                      ],
                    ),
                  )
                },
                icon: Icon(Icons.info),
              ),
              3: Container(),
              4: Container(),
            }[value.selectedPage]!,
          )
        ],
        title: Consumer<PageProvider>(
          builder: (context, value, child) => Text(
            value.getSelectedTitle(),
          ),
        ),
      ),
      body: Consumer<PageProvider>(
        builder: (context, value, child) => value.getPage(),
      ),
    );
  }
}
