import 'package:app/app.dart';
import 'package:app/home.dart';
import 'package:app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // App().removeLocal('user');

    return const MaterialApp(
      home: HomeWidget(),
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

  Future<Object?> getValue(path) async {
    try {
      DataSnapshot snapshot = await databaseReference.child(path).get();
      var value = snapshot.value;
      return value;
    } catch (error) {
      print('Failed to read value: $error');
      return 0; // Return a default value in case of an error
    }
  }

  Future<bool?> getValue12(String path) async {
    try {
      DataSnapshot snapshot = await databaseReference.child(path).get();
      bool? value = snapshot.value as bool?;
      return value;
    } catch (error) {
      print('Failed to read value: $error');
      return false; // Return a default value in case of an error
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
