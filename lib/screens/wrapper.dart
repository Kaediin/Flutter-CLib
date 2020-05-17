import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermclib/screens/authenticate/authenticate.dart';
import 'package:fluttermclib/screens/home/createWaypoint.dart';
import 'package:fluttermclib/screens/home/world_select.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    // Return either home or authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return WorldSelect();
    }
  }
}
