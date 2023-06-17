import 'package:app/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart_app/restart_app.dart';

class Counter extends ValueNotifier<String> {
  Counter() : super('0');

  void increment() {
    App().getLocal('user', (value1) {
      Future.delayed(Duration(seconds: 1), () {
        App().getValue12('workers/$value1/working').then((value12) {
          print(value1.toString() + ' sjakhkaghashkjlf');
          if (value12 == true) {
            value = 'Delate';
            notifyListeners();
          } else {
            value = 'Ne delate';
            notifyListeners();
          }
        });
      });
    });
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  void setUp1(BuildContext context) {
    DateTime now = DateTime.now();
    int dayOfMonth = now.day;
    int month = now.month;
    int year = now.year;

    String user;
    App().getLocal('user', (value) {
      print(value.toString() + 'samo to in pol');
      user = value.toString();
      if (user == 'null') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));

        print(user + 'sadsad');
      } else {
        App().getValue('workers/$user/working').then((value) {
          if (value == true) {
            App()
                .getValue('worker/$user/data/$year/$month/$dayOfMonth')
                .then((value) {
              if (value == 0 || value == null) {
                App().addItemToList(
                    'workers/$user/data/$year/$month/${dayOfMonth - 1}/time/stop',
                    '23:59:59');
                App().addItemToList(
                    'workers/$user/data/$year/$month/$dayOfMonth/time/start',
                    '00:00:01');
              }
            });
          }
        });
        print(user + 'sadsad1');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Counter counter = Counter();
    counter.increment();
    String working2 = '';
    String working1 = 'Loading';

    Future.delayed(Duration(seconds: 1), () {
      if (working2 == '1') {
        working1 = 'Delate';
      } else {
        working1 = 'Ne delate';
      }
    });

    setUp1(context);
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: [
          Container(
            height: 200,
          ),
          Image.network(
            'https://www.i-ms.si/wp-content/uploads/2023/02/IMS_logo-3.jpg',
          ),
          ValueListenableBuilder<String>(
              valueListenable: counter,
              builder: (context, value, _) {
                return Text(
                  'Status: $value',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                );
              }),
          const MainWidget(),
        ],
      )),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Counter counter = Counter();
    String working = '';
    String brake;
    String user = '';
    bool status1 = false;
    App().getLocal('user', (value) {
      user = value.toString();
      print('username: ' + user.toString());
    });

    App().getLocal('user', (value1) {
      Future.delayed(Duration(seconds: 1), () {
        App().getValue12('workers/$value1/working').then((value12) {
          if (value12 == true) {
            working = '1';
          } else {
            working = '0';
          }
        });
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      status1 = true;
    });

    void handleUserInput() {
      // Enable user input after 1 second
      Future.delayed(Duration(seconds: 1), () {
        counter.increment();
      });
    }

    checkLocationProximity();
    return Row(
      children: [
        Container(
          width: 75,
        ),
        Container(
          width: 100,
          height: 50,
          decoration: const BoxDecoration(color: Colors.green),
          child: TextButton(
            onPressed: () {
              DateTime now = DateTime.now();
              int dayOfMonth = now.day;
              int month = now.month;
              int year = now.year;
              String formattedTime = DateFormat('HH:mm:ss').format(now);

              if (working != '1' && status1 == true) {
                //TODO remove this
                //user = 'svit';
                App().getLocal('user', (value1) {
                  Future.delayed(Duration(seconds: 1), () {
                    App().getValue12('workers/$value1/working').then((value12) {
                      if (value12 == true) {
                        working = '1';
                      } else {
                        working = '0';
                      }
                    });
                  });
                });

                if (working != '1') {
                  App().addItemToList(
                      'workers/$user/data/$year/$month/$dayOfMonth/time/start',
                      formattedTime);
                  App().setValue('workers/$user/working', true);
                  working = '1';
                  Future.delayed(Duration(seconds: 1), () {
                    Restart.restartApp();
                  });
                } else {
                  print(2);
                }
              }
            },
            child: const Text('Začni'),
          ),
        ),
        Container(
          width: 50,
        ),
        Container(
          width: 100,
          height: 50,
          decoration: const BoxDecoration(color: Colors.red),
          child: TextButton(
            onPressed: () {
              DateTime now = DateTime.now();
              int dayOfMonth = now.day;
              int month = now.month;
              int year = now.year;
              //user = 'svit';

              String formattedTime = DateFormat('HH:mm:ss').format(now);
              App().getLocal('user', (value1) {
                Future.delayed(Duration(seconds: 1), () {
                  App().getValue12('workers/$value1/working').then((value12) {
                    if (value12 == true) {
                      working = '1';
                    } else {
                      working = '0';
                    }
                  });
                });
              });

              if (working == '1' && status1 == true) {
                App().addItemToList(
                    'workers/$user/data/$year/$month/$dayOfMonth/time/stop',
                    formattedTime);
                App().setValue('workers/$user/working', false);
                working = '0';
                Future.delayed(Duration(seconds: 1), () {
                  Restart.restartApp();
                });
              } else {
                // alrady working
                print(working);
              }
            },
            child: const Text('Ustavi'),
          ),
        )
      ],
    );
  }

  void checkLocationProximity() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle it accordingly
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, handle it accordingly
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Access the latitude and longitude
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Selected coordinate
    double selectedLatitude = 37.7749;
    double selectedLongitude = -122.4194;

    // Calculate distance between current position and selected coordinate
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      selectedLatitude,
      selectedLongitude,
    );

    // Check if the distance is within 500 meters
    if (distanceInMeters <= 500) {
      print('Within 500 meters of the selected coordinate');
    } else {
      print('Not within 500 meters of the selected coordinate');
    }
  }
}
