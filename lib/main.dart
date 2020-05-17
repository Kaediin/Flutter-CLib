import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermclib/screens/home/createWaypoint.dart';
import 'package:fluttermclib/screens/home/waypointView.dart';
import 'package:fluttermclib/screens/home/worldView.dart';
import 'package:fluttermclib/screens/wrapper.dart';
import 'package:fluttermclib/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        home: Wrapper(),
        routes: <String, WidgetBuilder>{
          "/createWaypoint" : (BuildContext context) => CreateWaypoint(),
          "/worldView" : (BuildContext context) => WorldView(),
          "/waypointView" : (BuildContext context) => WaypointView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
