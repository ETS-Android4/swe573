import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
                        labelText: 'Enter your username'),
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
            MaterialButton(
              height: 50,
              minWidth: MediaQuery.of(context).size.width,
              color: FunColor.fulvous,
              child: const Text('Log in',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              onPressed: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("or"),
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
