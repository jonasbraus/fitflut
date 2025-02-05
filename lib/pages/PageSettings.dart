import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitflut/providers/GymgoalProvider.dart';
import 'package:fitflut/providers/LoginProvider.dart';
import 'package:fitflut/workoutPages/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    String email = "";
    String password = "";

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
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Account",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<LoginProvider>(
                builder: (context, loginProv, child) {
                  if (LoginProvider.user == null) {
                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onChanged: (value) => email = value,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          obscureText: true,
                          onChanged: (value) => password = value,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FilledButton.icon(
                          onPressed: () async {
                            print(LoginProvider.user);
                            try {
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                              print(email);
                              print(password);
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              loginProv
                                  .login(FirebaseAuth.instance.currentUser!);
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Wrong Email or Password!")));
                            }
                          },
                          label: Text("Login"),
                          icon: Icon(Icons.person),
                        )
                      ],
                    );
                  }

                  return FilledButton.icon(
                    onPressed: () async {
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
                                await FirebaseAuth.instance.signOut(),
                                loginProv.logout(),
                                Navigator.of(context).pop()
                              },
                              label: Text("Logout",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              icon: Icon(
                                Icons.person,
                                color:
                                Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => {Navigator.of(context).pop()},
                              label: Text(LanguageProvider.getMap()["general"]
                              ["cancel"]),
                              icon: Icon(Icons.arrow_back),
                            )
                          ],
                        ),
                      );
                    },
                    label: Text("Logout"),
                    icon: Icon(Icons.person),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
