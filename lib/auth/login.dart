import 'package:appointment_app/auth/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../root.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _InternalLoginForm(),
    );
  }
}

class _InternalLoginForm extends StatefulWidget {
  @override
  _InternalLoginFormState createState() => _InternalLoginFormState();
}

class _InternalLoginFormState extends State<_InternalLoginForm> {
  @override
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController(),
      _passwordController = TextEditingController();

  void _callbackSuccessLogin(AuthResult authResult) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Root()),
    );
  }

  void _callbackFailLogin(PlatformException error, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
      ),
    );
  }

  void openRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 56.0),
      children: <Widget>[
        Text(
          "Sign in",
          style: Theme.of(context).textTheme.headline,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Text("Use your account"),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            hintText: "Email",
          ),
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(filled: true, hintText: "Password"),
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgetPassword(),
                  ),
                );
              },
              child: Text("Forget password?"),
            ),
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                _firebaseAuth
                    .signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    )
                    .then(
                      (authResult) => this._callbackSuccessLogin(authResult),
                    )
                    .catchError(
                      (data) => this._callbackFailLogin(data, context),
                    );
              },
            )
          ],
          alignment: MainAxisAlignment.end,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              child: Text("Sign up?"),
              onPressed: this.openRegistration,
            ),
          ],
        )
      ].map((res) {
        return Padding(
          child: res,
          padding: EdgeInsets.only(
            bottom: 8.0,
            left: 16.0,
            right: 16.0,
          ),
        );
      }).toList(),
    );
  }
}
