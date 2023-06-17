import 'package:app/popups/code.dart';
import 'package:flutter/material.dart';
import 'package:app/app.dart';

import 'main.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
            ),
            const Text(
              "Prijava",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'uporabniško ime',
              ),
            ),
            Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(color: Colors.blue),
              margin: const EdgeInsets.all(25),
              child: TextButton(
                onPressed: () {
//                  App().getValue('workers/svit/code');
                  App()
                      .getValue('workers/${myController.text}/code')
                      .then((value) {
                    print('Retrieved Value: $value');
                    // Use the retrieved value in your application logic
                    if (value != 0) {
                      App().setLocal('code', value.toString());
                      App().setLocal('tempsUser', myController.text);
                      App().botomSheetBuilder(const CodeWidget(), context);
                    }
                  });
                  //
                },
                child: const Text(
                  'Naprej',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
