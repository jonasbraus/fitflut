import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:fitflut/providers/PageProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initDb();

  runApp(const MyApp());
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
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const MyHome(),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
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
              icon: Icons.fastfood_rounded,
            ),
            GButton(
              icon: Icons.settings,
            )
          ],
          iconSize: 22,
          style: GnavStyle.google,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          curve: Curves.easeInCirc,
          padding: EdgeInsets.all(15),
          onTabChange: (value) =>
              Provider.of<PageProvider>(context, listen: false)
                  .changePage(value),
        ),
      ),
      appBar: AppBar(
        elevation: 5,
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
