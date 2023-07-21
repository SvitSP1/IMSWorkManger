import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Internet extends StatelessWidget {
  const Internet({super.key});

  @override
  Widget build(BuildContext context) {
    void check1() async {
      if (await App().checkInternet() == false) {
        Fluttertoast.showToast(
            msg: "internet ni najden",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Internet dela",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    }

    return Material(
      child: Center(
        child: Flex(direction: Axis.vertical, children: [
          Flexible(
            flex: 3,
            child: Container(),
          ),
          Flexible(
            flex: 7,
            child: Column(children: [
              const Text(
                'Ni interneta',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.w700),
              ),
              const Text(
                'Ta aplikacija potrebuje internet da deluje.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.wifi_off, size: 100),
              Container(
                width: 300,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(42),
                  border: Border.all(color: Colors.black, width: 7),
                ),
                child: TextButton(
                    onPressed: () {
                      check1();
                    },
                    child: const Text(
                      'Poskusi še enkrat',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w700),
                    )),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
