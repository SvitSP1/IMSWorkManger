import 'package:app/internet.dart';
import 'package:app/login.dart';
import 'package:app/main.dart';
import 'package:app/popups/nfc%20.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isWorking = false;
  String totalWorkTime = '0:00:00';

  void innit1() async {
    App().getLocal('user', (value) async {
      if (!(value == null) && !(value == '')) {
        print(value + ' --------------------------------');
        var working = await App().getValue('workers/$value/working');
        if (working == true) {
          setState(() {
            _isWorking = true;
          });
        } else {
          setState(() {
            _isWorking = false;
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

    if (_startArr != null) {
      List<dynamic> startArr = List.from(_startArr as Iterable<dynamic>);
      List<dynamic> stopArr = List.from(_stopArr as Iterable<dynamic>);
      try {
        String totalTimeResult = App().calculateTotalTime(
          App().convertDynamicListToStringList(startArr),
          App().convertDynamicListToStringList(stopArr),
        );
        setState(() {
          totalWorkTime = totalTimeResult;
        });
        print(totalTimeResult);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void workButton1(BuildContext context) async {
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

    print(bool1);
    if (!bool1) {
      App().toggleWorking(bool2 as bool, user);
      if (_startArr != null) {
        await sleep(1);
        List<dynamic> startArr = List.from(_startArr as Iterable<dynamic>);
        List<dynamic> stopArr = List.from(_stopArr as Iterable<dynamic>);
        try {
          String totalTimeResult = App().calculateTotalTime(
            App().convertDynamicListToStringList(startArr),
            App().convertDynamicListToStringList(stopArr),
          );
          setState(() {
            totalWorkTime = totalTimeResult;
          });
          print(totalTimeResult);
        } catch (e) {
          print('Error: $e');
        }
      }

      // try {
      //   String totalTimeResult = App().calculateTotalTime(
      //     App().convertDynamicListToStringList(startArr),
      //     App().convertDynamicListToStringList(stopArr),
      //   );
      //   print(totalTimeResult);
      // } catch (e) {
      //   print('Error: $e');
      // }
    } else {
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
              ),
            ),
          );
        },
      );
    }
  }

  void workButton() {
    workButton1(context);
    setState(() {
      _isWorking = !_isWorking;
    });
  }

  @override
  initState() {
    // ignore: avoid_print
    innit1();
    getTotalTime1();
  }

  @override
  Widget build(BuildContext context) {
    void check2() async {
      if (await App().checkInternet() == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Internet()),
        );
      }
    }

    check2();

    return Scaffold(
      body: Stack(
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
                        Container(
                          height: 20,
                        ),
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
                  flex: 3,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            height: 15,
                          ),
                          !_isWorking
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.black, width: 5)),
                                  width: 250,
                                  height: 100,
                                  child: TextButton(
                                    onPressed: workButton,
                                    child: const Text(
                                      'Začni',
                                      style: TextStyle(
                                        fontSize: 40,
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
                                  height: 100,
                                  child: TextButton(
                                    onPressed: workButton,
                                    child: const Text(
                                      'Ustavi',
                                      style: TextStyle(
                                        fontSize: 40,
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
                  child: Container(
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
                              Container(
                                width: 30,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.black, width: 5)),
                                width: 125,
                                height: 50,
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Začni',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    )),
                              ),
                              Container(
                                width: 30,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.black, width: 5)),
                                width: 125,
                                height: 50,
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Ustavi',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        Material(
                          color: HexColor('D9D9D9'),
                          child: const Text(
                            'Čas 0:00:00',
                            style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: HexColor('D9D9D9'),
                  borderRadius: BorderRadius.circular(42),
                  border: Border.all(color: Colors.black, width: 7)),
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Organiziraj dopust',
                    style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
