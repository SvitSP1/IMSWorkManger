import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class CodeWidget extends StatelessWidget {
  const CodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 80,
          child: Center(
            child: SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onSubmitted: (value) {
                  if (myController.text.isNotEmpty) {
                    String code = '';
                    String user = '';

                    App().getLocal('code', (value) {
                      code = value.toString();
                      App().getLocal('tempsUser', (value1) {
                        user = value1.toString();
                        if (code == myController.text) {
                          print('true' + 'sad');

                          App().setLocal('user', user);

                          Future.delayed(Duration(seconds: 1), () {
                            Restart.restartApp();
                          });
                        }
                      });
                    });

                    print("false" + code + myController.text);
                  }
                  Navigator.of(context).pop();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.grey.shade800,
                autofocus: true,
                autocorrect: false,
                controller: myController,
                style: TextStyle(
                    color: Colors.grey.shade800, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
