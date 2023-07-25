import 'package:app/internet.dart';
import 'package:app/login.dart';
import 'package:app/main.dart';
import 'package:app/popups/nfc%20.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  bool _isWorking = false;
  bool _isOnBrake = false;
  String totalWorkTime = '0:00:00';
  String totalBrakeTime = '0:00:00';

  void setLoad(bool) {
    if (bool) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void innit1() async {
    App().getLocal('user', (value) async {
      if (!(value == null) && !(value == '')) {
        print(value + ' --------------------------------');
        var working = await App().getValue('workers/$value/working');
        var isOnBreak = await App().getValue('workers/$value/break');
        if (working == true) {
          setState(() {
            _isWorking = true;
          });
        } else {
          setState(() {
            _isWorking = false;
          });
        }
        if (isOnBreak == true) {
          setState(() {
            _isOnBrake = true;
          });
        } else {
          setState(() {
            _isOnBrake = false;
          });
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  Future<void> sleep(int seconds) {
    return Future.delayed(Duration(seconds: seconds));
  }

  void getTotalTime1() async {
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/stop');

    bool bool3 = await App().getValue12('workers/$user/working') ?? false;

    if (_startArr != null) {
      List<dynamic> startArr =
          _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
      List<dynamic> stopArr =
          _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];

      try {
        String totalTimeResult = App().calculateTotalTime(
          App().convertDynamicListToStringList(startArr),
          App().convertDynamicListToStringList(stopArr),
        );
        setState(() {
          totalWorkTime = totalTimeResult;
        });
        if (bool3) {
          startUpdatingTotalBrakeTime1();
        }
        print(totalTimeResult);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void getTotalTime2() async {
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/stop');
    print(_startArr);
    bool bool3 = await App().getValue12('workers/$user/break') ?? false;
    if (_startArr != null) {
      List<dynamic> startArr =
          _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
      List<dynamic> stopArr =
          _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];

      try {
        String totalTimeResult = App().calculateTotalTime(
          App().convertDynamicListToStringList(startArr),
          App().convertDynamicListToStringList(stopArr),
        );
        setState(() {
          totalBrakeTime = totalTimeResult;
        });
        if (bool3) {
          startUpdatingTotalBrakeTime();
        }
        print(totalTimeResult);
      } catch (e) {
        print('Error: $e');
      }
    }
    setLoad(false);
  }

  void workButton1(BuildContext context) async {
    setLoad(true);
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>
    bool bool1 =
        await App().getValue12('workers/${user.toString()}/nfc') ?? false;
    bool bool2 = await App().getValue12('workers/$user/working') ??
        false; // Print the value of bool1 to check if it's null or not

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/stop');

    print(_startArr);
    if (!bool1) {
      if (bool2 == true) {
        bool bool3 = await App().getValue12('workers/$user/break') ?? false;
        if (bool3) {
          breakButon2(context, true);
        }
      }
      App().toggleWorking(bool2 as bool, user);

      if (_startArr != null) {
        await sleep(1);
        List<dynamic> startArr =
            _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
        List<dynamic> stopArr =
            _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];

        try {
          String totalTimeResult = App().calculateTotalTime(
            App().convertDynamicListToStringList(startArr),
            App().convertDynamicListToStringList(stopArr),
          );
          setState(() {
            totalWorkTime = totalTimeResult;
            _isWorking = !_isWorking;
          });
          startUpdatingTotalBrakeTime1();
          print(totalTimeResult);
          setLoad(false);
        } catch (e) {
          print('Error: $e');
        }
      } else {
        setState(() {
          _isWorking = !_isWorking;
        });
        startUpdatingTotalBrakeTime1();
        setLoad(false);
      }
    } else {
      setLoad(false);
      //ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(86), // Set the desired border radius
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  86), // Use the same border radius as the Dialog
              child: NfcWidget(
                description1: 'prisloni telefon k terminalu',
                title1: 'Začetek dela',
                description2: 'delo ste uspešno začeli',
                state1: 1,
                user: user,
                context: context,
                setLoadCallback: setLoad,
                fun1: workButton2,
                fun2: breakButon2,
              ),
            ),
          );
        },
      );
    }
    setLoad(false);
  }

  void workButton2(BuildContext context) async {
    setLoad(true);
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>
    bool bool1 =
        await App().getValue12('workers/${user.toString()}/nfc') ?? false;
    bool bool2 = await App().getValue12('workers/$user/working') ??
        false; // Print the value of bool1 to check if it's null or not

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/time/stop');

    print(_startArr);

    if (bool2 == true) {
      bool bool3 = await App().getValue12('workers/$user/break') ?? false;
      if (bool3) {
        breakButon2(context, true);
      }
    }
    App().toggleWorking(bool2 as bool, user);

    if (_startArr != null) {
      await sleep(1);
      List<dynamic> startArr =
          _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
      List<dynamic> stopArr =
          _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];

      try {
        String totalTimeResult = App().calculateTotalTime(
          App().convertDynamicListToStringList(startArr),
          App().convertDynamicListToStringList(stopArr),
        );
        setState(() {
          totalWorkTime = totalTimeResult;
          _isWorking = !_isWorking;
        });
        startUpdatingTotalBrakeTime1();
        print(totalTimeResult);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      setState(() {
        _isWorking = !_isWorking;
      });
      startUpdatingTotalBrakeTime1();
      setLoad(false);
    }
    setLoad(false);
  }

  void breakButon1(BuildContext context, bool bypass) async {
    setLoad(true);
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>
    bool bool1 =
        await App().getValue12('workers/${user.toString()}/nfc') ?? false;
    bool bool2 = await App().getValue12('workers/$user/working') ??
        false; // Print the value of bool1 to check if it's null or not

    bool bool3 = await App().getValue12('workers/$user/break') ?? false;

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/stop');
    if (bool2 || bypass) {
      print(_startArr);
      if (!bool1) {
        App().toggleBreak(bool2, bool3, user);
        if (_startArr != null) {
          await sleep(1);
          List<dynamic> startArr =
              _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
          List<dynamic> stopArr =
              _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];
          try {
            String totalTimeResult = App().calculateTotalTime(
              App().convertDynamicListToStringList(startArr),
              App().convertDynamicListToStringList(stopArr),
            );
            setState(() {
              totalBrakeTime = totalTimeResult;
              _isOnBrake = !_isOnBrake;
            });
            startUpdatingTotalBrakeTime();
            print(totalTimeResult);
          } catch (e) {
            print('Error: $e');
          }
        } else {
          setState(() {
            _isOnBrake = !_isOnBrake;
          });
          startUpdatingTotalBrakeTime();
          setLoad(false);
        }
      } else {
        //ignore: use_build_context_synchronously
        setLoad(false);
        //ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context1) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(86), // Set the desired border radius
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    86), // Use the same border radius as the Dialog
                child: NfcWidget(
                  description1: 'prisloni telefon k terminalu',
                  title1: 'Začetek dela',
                  description2: 'delo ste uspešno začeli',
                  state1: 2,
                  user: user,
                  context: context,
                  setLoadCallback: setLoad,
                  fun1: workButton2,
                  fun2: breakButon2,
                ),
              ),
            );
          },
        );
      }
    }
    setLoad(false);
  }

  void breakButon2(BuildContext context, bool bypass) async {
    setLoad(true);
    var user;
    App().getLocal('user', (value) {
      user = value;
    });
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    await sleep(1);
// Assuming getValue and getValue12 are asynchronous functions returning Future<bool>
    bool bool1 =
        await App().getValue12('workers/${user.toString()}/nfc') ?? false;
    bool bool2 = await App().getValue12('workers/$user/working') ??
        false; // Print the value of bool1 to check if it's null or not

    bool bool3 = await App().getValue12('workers/$user/break') ?? false;

    var _startArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/start');
    var _stopArr = await App().getValue(
        'workers/$user/data/$currentYear/$currentMonth/$currentDay/break/stop');
    if (bool2 || bypass) {
      print(_startArr);
      App().toggleBreak(bool2, bool3, user);
      if (_startArr != null) {
        await sleep(1);
        List<dynamic> startArr =
            _startArr is Iterable<dynamic> ? List.from(_startArr) : [];
        List<dynamic> stopArr =
            _stopArr is Iterable<dynamic> ? List.from(_stopArr) : [];

        try {
          String totalTimeResult = App().calculateTotalTime(
            App().convertDynamicListToStringList(startArr),
            App().convertDynamicListToStringList(stopArr),
          );
          setState(() {
            totalBrakeTime = totalTimeResult;
            _isOnBrake = !_isOnBrake;
          });
          startUpdatingTotalBrakeTime();
          print(totalTimeResult);
        } catch (e) {
          print('Error: $e');
        }
      } else {
        setState(() {
          _isOnBrake = !_isOnBrake;
        });
        startUpdatingTotalBrakeTime();
        setLoad(false);
      }
    }
    setLoad(false);
  }

  void startUpdatingTotalBrakeTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Increment the totalBrakeTime by 1 second and update the state
      if (_isOnBrake) {
        setState(() {
          totalBrakeTime = addOneSecond(totalBrakeTime);
        });
      } else {
        timer.cancel();
        return;
      }
    });
  }

  void startUpdatingTotalBrakeTime1() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Increment the totalBrakeTime by 1 second and update the state
      if (_isWorking) {
        setState(() {
          totalWorkTime = addOneSecond(totalWorkTime);
        });
      } else {
        timer.cancel();
        return;
      }
    });
  }

  String addOneSecond(String time) {
    // Assuming time is in the format HH:mm:ss
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Increment seconds and adjust minutes and hours accordingly
    seconds++;
    if (seconds >= 60) {
      seconds = 0;
      minutes++;
      if (minutes >= 60) {
        minutes = 0;
        hours++;
      }
    }

    // Convert back to the string format
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void workButton() {
    // workButton1(context);
    throw Exception();
  }

  void breakButton(bypass) async {
    breakButon1(context, bypass);
  }

  void check2() async {
    setLoad(true);
    if (await App().checkInternet() == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Internet()),
      );
    }
  }

  @override
  initState() {
    // ignore: avoid_print
    check2();
    innit1();
    getTotalTime1();
    getTotalTime2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Evidenca dela',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor('D9D9D9'),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: 270,
                            height: 170,
                            child: Center(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 230,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: StatefulBuilder(builder: (context, setState) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            !_isWorking
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.black, width: 5)),
                                    width: 260,
                                    height: 92,
                                    child: TextButton(
                                      onPressed: workButton,
                                      child: const Text(
                                        'Začni',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.black, width: 5)),
                                    width: 250,
                                    height: 80,
                                    child: TextButton(
                                      onPressed: workButton,
                                      child: const Text(
                                        'Ustavi',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              height: 5,
                            ),
                            Material(
                              child: Text(
                                'Čas: $totalWorkTime',
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                        ),
                        Container(
                          width: 340,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: HexColor('D9D9D9'),
                          ),
                          child: Column(
                            children: [
                              Material(
                                color: HexColor('D9D9D9'),
                                child: const Text(
                                  'Malica',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                height: 15,
                              ),
                              Center(
                                child: Row(
                                  children: [
                                    !_isOnBrake
                                        ? Row(
                                            children: [
                                              Container(
                                                width: 70,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 5)),
                                                width: 200,
                                                height: 60,
                                                child: TextButton(
                                                    onPressed: () {
                                                      breakButton(false);
                                                    },
                                                    child: const Text(
                                                      'Začni',
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black),
                                                    )),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: 70,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 5)),
                                                width: 200,
                                                height: 50,
                                                child: TextButton(
                                                    onPressed: () {
                                                      breakButton(false);
                                                    },
                                                    child: const Text(
                                                      'Ustavi',
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black),
                                                    )),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Material(
                                color: HexColor('D9D9D9'),
                                child: Text(
                                  'Čas: $totalBrakeTime',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
