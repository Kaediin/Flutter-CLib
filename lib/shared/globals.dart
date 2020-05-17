import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermclib/screens/models/waypoint.dart';
import 'package:fluttermclib/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String collection = '';
final admins = [
  "sZG5r72ycjNUsEegIGqII2auumz2"
];

bool isAdmin(FirebaseUser user){
  return admins.contains(user.uid);
}

List<Waypoint> overworldWaypoints = List<Waypoint>();
List<Waypoint> netherWaypoints = List<Waypoint>();
List<Waypoint> endWaypoints = List<Waypoint>();

final String OVERWORLD = "Overworld";
final String NETHER = "Nether";
final String END = "End";

Waypoint documentToWaypoint(DocumentSnapshot doc) {
  Waypoint waypoint =
  Waypoint(null, null, null, null, null, null, null, null);

  waypoint.name = doc.data['name'];
  waypoint.description = doc.data['description'];
  waypoint.world = doc.data['world'];
  waypoint.x = doc.data['x'];
  waypoint.y = doc.data['y'];
  waypoint.z = doc.data['z'];
  waypoint.cDate = doc.data['cDate'];
  waypoint.author = doc.data['author'];

  return waypoint;
}