
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermclib/services/auth.dart';
import 'package:fluttermclib/shared/constants.dart';
import 'package:fluttermclib/shared/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text('Sign in'),
//        actions: <Widget>[
//          FlatButton.icon(onPressed: () {
//            widget.toggleView();
//          }, icon: Icon(Icons.person), label: Text('Register'))
//        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                dynamic user = await _auth.signInWithGoogle();
              },
              child: Text("Sign in with Google", style: TextStyle(color: Colors.white),),
              color: Colors.blue[900],
            )
          ],
        ),
//        child: Form(
//          key: _formkey,
//          child: Column(
//            children: <Widget>[
//              SizedBox(height: 20),
//              TextFormField(
//                keyboardType: TextInputType.emailAddress,
//                decoration: textInputDecoration.copyWith(hintText: "Email"),
//                validator: (val) => val.isEmpty ? 'Enter an email' : null,
//                onChanged: (val) {
//                  setState(() {
//                    email = val;
//                  });
//                },
//              ),
//              SizedBox(height: 20),
//              TextFormField(
//                decoration: textInputDecoration.copyWith(hintText: "Password"),
//                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
//                onChanged: (val) {
//                  setState(() {
//                    password = val;
//                  });
//                },
//                obscureText: true,
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              RaisedButton(
//                color: Colors.brown,
//                child: Text('Sign In', style: TextStyle(color: Colors.white)),
//                onPressed: () async {
//                  HapticFeedback.vibrate();
//                  if (_formkey.currentState.validate()) {
//                    setState(() {
//                      loading = true;
//                    });
//                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
//                    if (result == null) {
//                      setState(() {
//                        error = 'Invalid credentials';
//                        loading = false;
//                      });
//                    } else {
//                      FirebaseUser user = result;
//                      print(user.email);
//                    }
//                  } else {
//                    print('Form not valid');
//                  }
//                },
//              ),
//              SizedBox(
//                height: 12.0,
//              ),
//              Text(
//                error,
//                style: TextStyle(color: Colors.red, fontSize: 14.0),
//              )
//            ],
//          ),
//        ),
      ),
    );
  }
}
