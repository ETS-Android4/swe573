import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/interest.dart';
import 'package:funxchange/models/new_user.dart';

import '../framework/colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
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
                          labelText: 'Enter your email address'),
                      controller: _emailController,
                      validator: (s) {
                        if (s == null || s.isEmpty || !s.isValidEmail()) {
                          return 'Please enter a valid email address.';
                        }
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your username'),
                        controller: _userNameController,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return 'Please enter a username.';
                          }

                          if (s.length < 4 || s.length > 31) {
                            return 'Username length must be between 4 and 32 characters';
                          }
                        }),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your bio'),
                        controller: _bioController,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return 'Please enter a bio.';
                          }
                        }),
                    TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your password'),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _passwordController,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return 'Please enter a password.';
                          }

                          if (s.length < 4 || s.length > 31) {
                            return 'Password length must be between 4 and 1024 characters';
                          }
                        }),
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
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signing up...')),
                  );

                  final model = NewUserParams(
                    _userNameController.text,
                    _bioController.text,
                    [Interest.golf], // TODO: implement interest picker
                    _passwordController.text,
                  );

                  DIContainer.mockSingleton.authRepo.signUp(model).then((resp) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Successfully signed up.')),
                    );
                    Navigator.of(context).pop(resp);
                  }).onError((error, _) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
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

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
