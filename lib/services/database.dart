import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttermclib/screens/models/waypoint.dart';
import 'package:fluttermclib/services/auth.dart';
import 'package:fluttermclib/shared/globals.dart';
import 'package:provider/provider.dart';

class DatabaseService {
//  final CollectionReference ref = Firestore.instance.collection("waypoints");
  final CollectionReference ref = Firestore.instance.collection(collection);

  Future addWaypoint(Waypoint waypoint) async {
    bool isCompleted = false;
    if (await isUnique(waypoint.name)) {
      DateTime now = new DateTime.now();
      waypoint.cDate =
          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";

      await ref.document(waypoint.name).setData({
        'name': waypoint.name,
        'description': waypoint.description,
        'x': waypoint.x,
        'y': waypoint.y,
        'z': waypoint.z,
        'world': waypoint.world,
        'cDate': waypoint.cDate,
        'author': waypoint.author
      }).whenComplete(() {
        print("Succesfully uploaded file");
        isCompleted = true;
      }).catchError((e) {
        print("Error: " + e.toString());
      });
    }
    return isCompleted;
  }

  Future addNewWorld(String name) async {
    bool isCompleted = false;

    final CollectionReference allColRef =
        Firestore.instance.collection("allCollections");

    await allColRef.document(name).setData({'name': name}).whenComplete(() {
      print("Complete");
      isCompleted = true;
    }).catchError((e) {
      print("Error: " + e.toString());
    });
    return isCompleted;
  }

  Future<bool> isUnique(String name) async {
    List<DocumentSnapshot> docs = List<DocumentSnapshot>();

    await ref.getDocuments().then((snapshot) {
      docs.addAll(snapshot.documents);
    });

    for (DocumentSnapshot doc in docs) {
      if (doc.documentID == name) {
        print('Is duplicate');
        print('${doc.documentID} \n$name');
        return Future<bool>.value(false);
      }
    }

    return Future<bool>.value(true);
  }

  void removeWaypoint(Waypoint waypoint) async {
    try {
      await ref.document(waypoint.name).delete();
    } catch (e) {}
  }

  Future<List<String>> getCollections() async {
    final CollectionReference allColRef =
        Firestore.instance.collection("allCollections");

    List<String> colIds = List<String>();

    await allColRef.getDocuments().then((snapshot) {
      snapshot.documents.forEach((doc) {
        colIds.add(doc.documentID);
      });
    });

    return colIds;
  }

  Future setAllWaypointsFromCollection() async {
    List<DocumentSnapshot> docs = List<DocumentSnapshot>();
    List<Waypoint> waypoints = List<Waypoint>();

    overworldWaypoints.clear();
    netherWaypoints.clear();
    endWaypoints.clear();

    await ref.getDocuments().then((snapshot) {
      docs.addAll(snapshot.documents);
    });

    for (DocumentSnapshot snapshot in docs) {
      Waypoint waypoint = documentToWaypoint(snapshot);
      waypoints.add(waypoint);
    }

    for (Waypoint waypoint in waypoints) {
      switch (waypoint.world) {
        case 'Overworld':
          overworldWaypoints.add(waypoint);
          break;

        case 'Nether':
          netherWaypoints.add(waypoint);
          break;

        case 'End':
          endWaypoints.add(waypoint);
          break;
      }
    }
  }
}
