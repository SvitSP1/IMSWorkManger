import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  String name = '';

  void init1() async {
    var name1 = await App().getValue('/info/name');

    setState(() {
      name = name1.toString();
    });
  }

  void Login() async {
    if (!(username == '' && username == '')) {
      var password1 = await App().getValue('workers/' + username + '/code');
      print('-------------------- ' + password1.toString());
      if (!(password1.toString() == '')) {
        if (password1.toString() == password) {
          Fluttertoast.showToast(
              msg: "Uspešno prijavljen!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          App().setLocal('user', username);
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: "Narobe geslo ali uporabniško ime.21",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Narobe geslo ali uporabniško ime.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Prosimo upišite use podatke.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  initState() {
    // ignore: avoid_print
    init1();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'demin.si prijava',
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 8,
            child: Stack(
              children: [
                Positioned(
                    left: 30,
                    right: 30,
                    top: 0,
                    child: Text(
                      'uporabnisko ime',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 26),
                    )),
                Positioned(
                  left: 30,
                  right: 30,
                  top: 40,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      decoration: BoxDecoration(
                        color: HexColor('D9D9D9'),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 5),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Janez1',
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      )),
                ),
                Positioned(
                    left: 30,
                    right: 30,
                    top: 110,
                    child: Text(
                      'geslo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    )),
                Positioned(
                  left: 30,
                  right: 30,
                  top: 150,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      decoration: BoxDecoration(
                        color: HexColor('D9D9D9'),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 5),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: '**************'),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      )),
                ),
                Positioned(
                    left: 30,
                    right: 30,
                    top: 240,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor('D9D9D9'),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Login();
                        },
                        child: Text('Prijava',
                            style: TextStyle(
                              fontSize: 42,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
