import 'package:flutter/material.dart';
import 'package:jufa/service/AuthService.dart';
import 'package:provider/provider.dart';

import 'pages/Home.dart';
import 'service/AppService.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
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
          future: AppService.initApp(),
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
