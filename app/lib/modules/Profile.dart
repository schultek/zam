import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';

class Profile extends StatelessWidget {
  TripUser user;
  Profile(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  user.nickname = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
