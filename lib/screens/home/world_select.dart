import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermclib/services/auth.dart';
import 'package:fluttermclib/services/database.dart';
import 'package:fluttermclib/shared/globals.dart';
import 'package:provider/provider.dart';

class WorldSelect extends StatefulWidget {
  @override
  _WorldSelectState createState() => _WorldSelectState();
}

class _WorldSelectState extends State<WorldSelect> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  final DatabaseService _dbService = DatabaseService();
  String dropDownValue;
  String error = '';
  List<String> colIds = List<String>();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    fillCollIds();
    return Scaffold(
        appBar: AppBar(
          title: Text('World Select'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.singOut();
                },
                icon: Icon(Icons.person, color: Colors.white,),

                label: Text('Logout', style: TextStyle(color: Colors.white),))
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Center(
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      decoration:
                          new InputDecoration(hintText: "World Select"),
                      items: colIds
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: dropDownValue,
                      onChanged: (value) {
                        setState(() {
                          collection = value;
                          dropDownValue = value;
                        });
                      },
                      validator: (val) =>
                          collection == null || collection == ""
                              ? 'Choose a world'
                              : null,
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.teal,
                      child: Text(
                        'Select',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/worldView");
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: fab(user));
  }

  void _showDialog() {
    String newWorldName;
    final _formkey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create new world"),
            actions: <Widget>[
              Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width:  (MediaQuery.of(context).size.width * 1),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                            decoration: new InputDecoration(hintText: "Enter new world name", contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0)),
                            validator: (val) =>
                              val.isEmpty ? 'Enter a name' : null,
                          onChanged: (name) {
                            setState(() {
                              newWorldName = name;
                            });
                          },
                        ),
                      )
                    ],
                  )),
              FlatButton(
                child: Text("Add"),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    dynamic result = await _dbService.addNewWorld(newWorldName);
                    print(result);
                    if (result) {
                      setState(() {
                        fillCollIds();
                        Navigator.of(context).pop();
                      });
                    } else {
                      setState(() {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Error creating world"),
                        ));
                      });
                    }
                  }
                },
              )
            ],
          );
        });
  }

  Widget fab(FirebaseUser user) {
    if (isAdmin(user)) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog();
        },
      );
    } else {
      return null;
    }
  }

  void fillCollIds() async {
    List<String> ids = await _dbService.getCollections();
    setState(() {
      colIds = ids;
    });
  }
}
