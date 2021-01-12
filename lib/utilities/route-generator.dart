import 'package:flutter/material.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/pages/home-page.dart';
import 'package:home_secure/pages/login-page.dart';
import 'package:home_secure/pages/register.dart';
import 'package:home_secure/utilities/constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());

      default:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
    } //switch
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Page'),
          backgroundColor: googleColor,
        ),
        body: Center(
          child: Text('AN ERROR HAS OCCURRED!'),
        ),
      );
    });
  } //error ROUTE
} //end RouteGenerator
