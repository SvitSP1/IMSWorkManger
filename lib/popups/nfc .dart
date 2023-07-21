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

  const NfcWidget({
    Key? key,
    required this.description1,
    required this.description2,
    required this.title1,
    required this.state1,
    required this.user,
  }) : super(key: key);

  @override
  State<NfcWidget> createState() => NfcWidgetState();
}

class NfcWidgetState extends State<NfcWidget> {
  String _tagId = '';
  bool _isListening = false;
  bool _isDone = false;
  late Stream<NfcTag> _tagStream;

  Future<void> android1() async {
    List<String> _id = App().getValue('info/tags') as List<String>;
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var tagId = tag.data['nfca']['identifier'];
      if (_id.contains(tagId)) {
        print('Susscesfully indentefied.');
        setState(() {
          _isDone = true;
        });
      }
      print(
          '------------------------------------------------------ ${tagId.toString() == '[4, 36, 97, 98, 236, 107, 129]'}');
      // setState(() {
      //   _tagId = tagId;
      // });
    });
  }

  void startFun() {
    if (Platform.isAndroid) {
      android1();
    } else if (Platform.isIOS) {
      // iOS-specific code
    }
  }

  @override
  void initState() {
    super.initState();
    startFun();
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
