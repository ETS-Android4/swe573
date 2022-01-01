import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/auth_params.dart';
import 'package:funxchange/models/auth_response.dart';
import 'package:funxchange/screens/signup.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.onAuth}) : super(key: key);

  final Function(List<String>) onAuth;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _usernameController,
                      validator: (s) {
                        if (s == null || s.isEmpty) {
                          return 'Please enter your username.';
                        }
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your password'),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _passController,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return 'Please enter your password.';
                          }
                        }),
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
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Creating event...')),
                  );

                  final model = AuthParams(
                      _usernameController.text, _passController.text);
                  DIContainer.activeSingleton.authRepo
                      .authenticate(model)
                      .then((resp) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Logged in successfully.')),
                    );
                    widget.onAuth([resp.jwt, model.userName]);
                  }).onError((error, _) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  });
                },
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return const SignUpPage();
                  })).then((value) {
                    if (value is List<String>) widget.onAuth(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
