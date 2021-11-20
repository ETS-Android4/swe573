import 'package:flutter/material.dart';

import '../framework/colors.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your email address'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your bio'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your password'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 50,
              minWidth: MediaQuery.of(context).size.width,
              color: FunColor.fulvous,
              child: const Text('Sign up',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
