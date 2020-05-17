import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermclib/screens/models/waypoint.dart';
import 'package:fluttermclib/services/database.dart';
import 'package:fluttermclib/shared/constants.dart';
import 'package:fluttermclib/shared/loading.dart';
import 'package:provider/provider.dart';

class CreateWaypoint extends StatefulWidget {
  @override
  _CreateWaypointState createState() => _CreateWaypointState();
}

class _CreateWaypointState extends State<CreateWaypoint> {
  final _formkey = GlobalKey<FormState>();
  final _dbService = DatabaseService();

  Waypoint waypoint = Waypoint(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null);
  String error = '';
  String dropDownValue;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: Text('Create new waypoint'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                DropdownButtonFormField(
                  iconSize: 40,
                  iconEnabledColor: Colors.white,
                  decoration: new InputDecoration(
                    hintText: "World",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)
                  ),
                  items: <String>['Overworld', 'Nether', 'End']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: dropDownValue,
                  onChanged: (value) {
                    setState(() {
                      waypoint.world = value;
                      dropDownValue = value;
                    });
                  },
                  validator: (val) => waypoint.world == null ? 'Choose a world' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: waypointTextInputDecoration.copyWith(
                      hintText: "Name"),
                  validator: (val) => val.isEmpty ? 'Enter a name' : null,
                  onChanged: (name) {
                    setState(() {
                      waypoint.name = name;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: waypointTextInputDecoration.copyWith(
                      hintText: "Description (optional)"),
                  onChanged: (description) {
                    setState(() {
                      waypoint.description = description;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  validator: (val) => val.isEmpty ? 'Enter a X coordinate' : null,
                  decoration: waypointTextInputDecoration.copyWith(
                      hintText: "X Coordinate"
                  ),
                  onChanged: (x) {
                    setState(() {
                      waypoint.x = x;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  validator: (val) => val.isEmpty ? 'Enter a Y coordinate' : null,
                  decoration: waypointTextInputDecoration.copyWith(
                      hintText: "Y Coordinate"
                  ),
                  onChanged: (y) {
                    setState(() {
                      waypoint.y = y;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  validator: (val) => val.isEmpty ? 'Enter a Z coordinate' : null,
                  decoration: waypointTextInputDecoration.copyWith(
                      hintText: "Z Coordinate"
                  ),
                  onChanged: (z) {
                    setState(() {
                      waypoint.z = z;
                    });
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    HapticFeedback.vibrate();
                    print(waypoint.world);
                    if (_formkey.currentState.validate()) {

                      FirebaseUser user = Provider.of<FirebaseUser>(context);
                      waypoint.author = user.displayName;
                      dynamic result =
                      await _dbService.addWaypoint(waypoint);
                      if (result == true) {
                        print(result);
                        setState(() {
                          error = '';
                          Navigator.of(context).pop();
                        });
//                            Navigator.pop(context);
                      } else {
                        print(result);
                        setState(() {
                          error =
                          'Failed to submit form. Perhaps this name already exists';
                        });
                      }
                    } else {
                      setState(() {
                        error = 'Please fill in all the required fields';
                      });
                    }
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
    );
  }
}
