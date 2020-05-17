import 'package:flutter/material.dart';
import 'package:fluttermclib/screens/models/waypoint.dart';
import 'package:fluttermclib/shared/constants.dart';



class WaypointView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Waypoint waypoint = ModalRoute.of(context).settings.arguments as Waypoint;

    return Scaffold(
      appBar: AppBar(title: Text(waypoint.name),),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(waypoint.description, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(waypoint.x, style: xyzTextStyle),
                SizedBox(width: 25,),
                Text(waypoint.y, style: xyzTextStyle),
                SizedBox(width: 25,),
                Text(waypoint.z, style: xyzTextStyle),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(waypoint.author),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(waypoint.cDate),
              ],
            )
          ],
        ),
      ),
    );
  }
}
