import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:core';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC2avdImgYjTlCcoqsFdQ651fQ4OQ3piD8",
      authDomain: "workmanager-bf739.firebaseapp.com",
      databaseURL: "https://workmanager-bf739-default-rtdb.firebaseio.com/",
      projectId: "workmanager-bf739",
      storageBucket: "workmanager-bf739.appspot.com",
      messagingSenderId: "1026107424905",
      appId: "1:1026107424905:web:236b5f90ab278ec0b90658",
      measurementId: "G-5WGSCME9R6",
    ),
  );
  bool dataExists = App().checkDataExistence('working');

  if (!dataExists) {
    App().setLocal('working', '0');
  }

  bool dataExists1 = App().checkDataExistence('brake');

  if (!dataExists1) {
    App().setLocal('brake', '0');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    bool dataExists = App().checkDataExistence('user');

    var smt1 = false;
    if (false) {
      print('-------------------------------------------------------------');
      print('---------------------Remove acc is on------------------------');
      print('-------------------------------------------------------------');
      App().removeLocal('user');
    }
    //
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: HomeScreen(),
    );

    // if (smt1 == true) {

    // } else {
    //   print(smt1.toString() + "adagljhkf");
    //   return const MaterialApp(
    //     home: LoginView(),
    //   );
    // }
  }
}

class App {
  final databaseReference = FirebaseDatabase.instance.reference();

  void setValue(path, data) {
    databaseReference.child(path).set(data).then((_) {
      print('Value set successfully.');
    }).catchError((error) {
      print('Failed to set value: $error');
    });
  }

  List<String> convertDynamicListToStringList(List<dynamic> dynamicList) {
    return dynamicList.map((item) => item.toString()).toList();
  }

  String calculateTotalTime(List<String> starts, List<String> finishes) {
    int totalSeconds = 0;

    int iterations =
        starts.length < finishes.length ? starts.length : finishes.length;

    for (int i = 0; i < iterations; i++) {
      List<String> startTimeSplit = starts[i].split(':');
      if (startTimeSplit.length != 3) {
        throw FormatException('Invalid format for start time at index $i');
      }
      int startHours = int.parse(startTimeSplit[0]);
      int startMinutes = int.parse(startTimeSplit[1]);
      int startSeconds = int.parse(startTimeSplit[2]);

      List<String> finishTimeSplit = finishes[i].split(':');
      if (finishTimeSplit.length != 3) {
        throw FormatException('Invalid format for finish time at index $i');
      }
      int finishHours = int.parse(finishTimeSplit[0]);
      int finishMinutes = int.parse(finishTimeSplit[1]);
      int finishSeconds = int.parse(finishTimeSplit[2]);

      // Convert start and finish times to seconds
      int startTimeInSeconds =
          startHours * 3600 + startMinutes * 60 + startSeconds;
      int finishTimeInSeconds =
          finishHours * 3600 + finishMinutes * 60 + finishSeconds;

      // Calculate time difference between start and finish
      totalSeconds += finishTimeInSeconds - startTimeInSeconds;
    }

    // Handle the case where there are more starts than finishes
    if (starts.length > finishes.length) {
      // Add the current time as a stop time
      DateTime currentTime = DateTime.now();
      int currentSeconds = currentTime.hour * 3600 +
          currentTime.minute * 60 +
          currentTime.second;

      // Convert start and current times to seconds
      List<String> lastStartTimeSplit = starts.last.split(':');
      int lastStartHours = int.parse(lastStartTimeSplit[0]);
      int lastStartMinutes = int.parse(lastStartTimeSplit[1]);
      int lastStartSeconds = int.parse(lastStartTimeSplit[2]);
      int lastStartTimeInSeconds =
          lastStartHours * 3600 + lastStartMinutes * 60 + lastStartSeconds;

      // Calculate time difference between start and current time
      totalSeconds += currentSeconds - lastStartTimeInSeconds;
    }

    // Format and return the result
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<Object?> getValue(path) async {
    try {
      DataSnapshot snapshot = await databaseReference.child(path).get();
      var value = snapshot.value;
      print('value: $value and path: $path');
      return value;
    } catch (error) {
      print('Failed to read value: $error');
      return '0'; // Return a default value in case of an error
    }
  }

  Future<bool?> getValue12(String path) async {
    try {
      DataSnapshot snapshot = await databaseReference.child(path).get();

      bool? value = snapshot.value as bool?;
      print('reading value111: ${value} nad path: $path');
      return value;
    } catch (error) {
      print('Failed to read value: $error');
      return false; // Return a default value in case of an error
    }
  }

  Future<bool?> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: avoid_print
      print('No internet connection');
      return false;
    } else {
      // ignore: avoid_print
      print('Internet connection is available');
      return true;
    }
  }

  Future<List<dynamic>?> getValue1(String path) async {
    try {
      DataSnapshot snapshot = await databaseReference.child(path).get();
      List<dynamic>? originalArray = snapshot.value as List<dynamic>?;
      return originalArray;
    } catch (error) {
      print('Failed to read value: $error');
      return null; // Return null in case of an error
    }
  }

  void addItemToList(String listPath, dynamic newItem) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.reference().child(listPath);

    DatabaseEvent event = await databaseRef.once();

    List<dynamic> list = [];

    if (event.snapshot.value != null) {
      list = List<dynamic>.from(event.snapshot.value as Iterable<dynamic>);
    }

    list.add(newItem);

    databaseRef.set(list);
  }

  void botomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: ((context) {
          return bottomSheetView;
        }));
  }

  void toggleWorking(bool working, user) async {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;

    // get current data hh/ss/mm format
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    // Print the formatted time
    if (working) {
      addItemToList(
          'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/stop',
          formattedTime);
      setValue('workers/$user/working', false);
    } else {
      addItemToList(
          'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/start',
          formattedTime);
      setValue('workers/$user/working', true);
    }
  }

  bool doesVariableExist(String key) {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.containsKey(key);
    });
    return false;
  }

  bool checkDataExistence(path) {
    bool exists = doesVariableExist(path);
    return exists;
  }

  void getLocal(path, void Function(String? value) callback) {
    SharedPreferences.getInstance().then((prefs) {
      String? value = prefs.getString(path);
      print(value.toString() + ' fhaghajghjasdjhgajdhgaslghh');
      callback(value);
    }).catchError((error) {
      print('Error: $error');
      callback(null);
    });
  }

  Future<void> removeLocal(String key) {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.remove(key);
    }).catchError((error) {
      print('Failed to remove value: $error');
    });
  }

  Future<void> setLocal(String key, String value) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    });
  }
}
