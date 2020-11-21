import 'package:flutter/material.dart';

import '../../general/Module.dart';
import '../../models/Trip.dart';

class Profile extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Profil")),
          ),
          onTap: () {
            Navigator.of(context).push(ModulePageRoute(context, child: ProfilePage(data.trip.currentUser())));
          },
        ),
      ),
    ];
  }
}

class ProfilePage extends StatelessWidget {
  final TripUser user;

  ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  user.nickname = text;
                },
              ),
              Expanded(child: LayeredStack()),
            ],
          ),
        ),
      ),
    );
  }
}

class LayeredStack extends StatefulWidget {
  @override
  _LayeredStackState createState() => _LayeredStackState();
}

class _LayeredStackState extends State<LayeredStack> {
  var reversed = false;
  List<Widget> children;

  @override
  void initState() {
    super.initState();
    this.children = [
      StatefulChild(
      key: UniqueKey(),
          color: Colors.blue.withOpacity(0.5),
          onPressed: () => setState(() => reversed = !reversed),
        ),
      StatefulChild(
        key: UniqueKey(),
          color: Colors.red.withOpacity(0.5),
          onPressed: () => setState(() => reversed = !reversed),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        ...(reversed ? children.reversed.toList() : children)
      ],
    );
  }
}


class StatefulChild extends StatefulWidget {

  final Color color;
  final Function() onPressed;

  StatefulChild({this.color, this.onPressed, Key key}) : super(key: key);

  @override
  _StatefulChildState createState() => _StatefulChildState();
}

class _StatefulChildState extends State<StatefulChild> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: widget.color,
      child: RaisedButton(
        child: Text("$counter"),
        onPressed: () {
          setState(() {
            this.counter++;
          });
          widget.onPressed();
        },
      ),
    );
  }
}
