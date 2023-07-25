import 'package:app/home.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io' show Platform;
import 'package:nfc_manager/nfc_manager.dart';

class NfcWidget extends StatefulWidget {
  final String title1;
  final String description1;
  final String description2;
  final int state1;
  final String user;
  final BuildContext context;
  final Function(bool) setLoadCallback;
  final Function(BuildContext) fun1;
  final Function(BuildContext, bool) fun2;

  const NfcWidget(
      {Key? key,
      required this.description1,
      required this.description2,
      required this.title1,
      required this.state1,
      required this.user,
      required this.context,
      required this.setLoadCallback,
      required this.fun1,
      required this.fun2})
      : super(key: key);

  @override
  State<NfcWidget> createState() => NfcWidgetState();
}

class NfcWidgetState extends State<NfcWidget> {
  String _tagId = '';
  bool _isListening = false;
  bool _isDone = false;
  late Stream<NfcTag> _tagStream;

  Future<void> android1() async {
    print('Attempted listening!');
    List<Object?> _id = await App().getValue('info/tags') as List<Object?>;
    print('Started listenning');
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var tagId = tag.data['nfca']['identifier'];
      if (_id.contains(tagId.toString())) {
        print('Susscesfully indentefied. $tagId');
        setState(() {
          _isDone = true;
        });
        if (widget.state1 == 1) {
          widget.fun1(widget.context);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else if (widget.state1 == 2) {
          widget.fun2(widget.context, false);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        }
      }
      print(
          '------------------------------------------------------ ${tagId.toString() == '[4, 115, 96, 98, 236, 107, 129]'}');
      print('Susscesfully not indentefied. $tagId');

      // setState(() {
      //   _tagId = tagId;
      // });
    });
  }

  void startFun() {
    if (Platform.isAndroid) {
      android1();
    } else if (Platform.isIOS) {
      android1();
    }
  }

  @override
  void initState() {
    super.initState();
    startFun();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    print('stopped, and disposing');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDone) {
      return Container(
        height: 196,
        width: 279,
        decoration: BoxDecoration(
          color: HexColor('D9D9D9'),
        ),
        child: Center(
            child: Icon(
          Icons.check_circle, // Scale width by 0.5
          size: 180, color: Colors.green,
        )),
      );
    } else {
      return Container(
        height: 196,
        width: 279,
        decoration: BoxDecoration(
          color: HexColor('D9D9D9'),
        ),
        child: Center(
          child: Image.asset(
            'assets/nfc.png',
            fit: BoxFit.contain,
            width: 2 * 279, // Scale width by 0.5
            height: 2 * 196, // Scale height by 0.5
          ),
        ),
      );
    }
  }
}
