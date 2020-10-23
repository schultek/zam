import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/Home.dart';
import 'service/AppService.dart';
import 'service/AuthService.dart';
import 'service/DatabaseService.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
    ChangeNotifierProvider<DatabaseService>(create: (context) => DatabaseService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: AppService.initApp().then((user) => Provider.of<AuthService>(context, listen: false).updateAll(user)),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Home();
            } else {
              return Container();
            }
          }),
    );
  }
}
