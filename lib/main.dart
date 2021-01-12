import 'package:flutter/material.dart';
import 'package:home_secure/utilities/constants.dart';
import 'package:home_secure/utilities/route-generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Secure',
      theme: ThemeData(
        canvasColor: colorWhite,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
