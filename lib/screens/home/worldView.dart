import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermclib/screens/models/waypoint.dart';
import 'package:fluttermclib/services/database.dart';
import 'package:fluttermclib/shared/globals.dart';

class WorldView extends StatefulWidget {
  @override
  _WorldViewState createState() => _WorldViewState();
}

class _WorldViewState extends State<WorldView>
    with SingleTickerProviderStateMixin {
  List<Widget> containers;
  final _dbService = DatabaseService();

  /*
  Widget listViewOverworld;
  Widget listViewNether;
  Widget listViewEnd;

  @override
  void initState() {
    super.initState();

    Widget buildListView(String worldType) {
      return StreamBuilder(
          stream: Firestore.instance.collection(collection).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            try {
              if (snapshot.data.documents.isNotEmpty) {
                return ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) {
                    final waypoint =
                        documentToWaypoint(snapshot.data.documents[index]);
                    print("Waypoint: " + waypoint.world);
                    if (waypoint.world == worldType) return listItem(waypoint);
                    return null;
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No waypoints set yet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                );
              }
            } catch (e) {
              return Center(
                child: Text(
                  'No waypoints set yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
            }
          });
    }

    listViewOverworld = buildListView(OVERWORLD);
    listViewNether = buildListView(NETHER);
    listViewEnd = buildListView(END);


  }

   */

//  Future setValues() async {
//    dynamic result = await _dbService.setAllWaypointsFromCollection();
//    return result;
//  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(collection),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Overworld',
              ),
              Tab(
                text: 'Nether',
              ),
              Tab(
                text: 'End',
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _dbService.setAllWaypointsFromCollection(),
          builder: (context, snapshot) {
            return TabBarView(
              children: [
                Container(
                  child: buildListView(overworldWaypoints),
                ),
                Container(
                  child: buildListView(netherWaypoints),
                ),
                Container(
                  child: buildListView(endWaypoints),
                ),
              ],
            );
          }, //
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/createWaypoint");
          },
          child: Icon(Icons.add_location),
        ),
      ),
    );
  }

  Widget buildListView(List<Waypoint> waypoints) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          try {
//            if (waypoints.isNotEmpty) {
            return listItem(waypoints[i]);
//            } else
//            }
          } catch (e) {
            return null;
//            return Center(
//              child: Text(
//                'No waypoints set yet',
//                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//              ),
//            );
          }
        });
  }

  Widget listItem(Waypoint waypoint) {
    return ListTile(
      title: Text(
        waypoint.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Icon(Icons.location_on),
      onTap: () {
        Navigator.of(context).pushNamed("/waypointView", arguments: waypoint);
      },
      onLongPress: () {
        setState(() {
          _showPopupMenu(waypoint);
        });
      },
      trailing: Text(
        waypoint.world,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  void _showPopupMenu(Waypoint waypoint) async {
    final _dbService = DatabaseService();

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: Text("Delete"),
            trailing: Icon(Icons.delete),
            onTap: () {
              setState(() {
                _dbService.removeWaypoint(waypoint);
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }
}
