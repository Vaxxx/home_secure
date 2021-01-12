import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/pages/login-page.dart';
import 'package:home_secure/pages/register.dart';
import 'package:home_secure/utilities/constants.dart';

class HomePage extends StatefulWidget {
  static String HOME_EMAIL = '';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    // googleSignIn.signInSilently(suppressErrors: false).then((account) {
    //   handleSignIn(account);
    //   _currentUser = account;
    //   print('The current user is: ${_currentUser.email}');
    //   HomePage.HOME_EMAIL = _currentUser.email;
    // }).catchError((err) {
    //   print('Error signing in: $err');
    // });
    super.initState();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Dashboard(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait();
    } else {
      return landscape();
    }
  }

  Widget portrait() {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: mainBg,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset('assets/images/logo.png')),
        SizedBox(
          height: 140,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 100.0,
                  buttonColor: homeColor,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Login",
                          style: fontWhite,
                        ),
                      )),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 100.0,
                  buttonColor: homeColor,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Register",
                        style: fontWhite,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    ]));
  }

  Widget landscape() {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: mainBg,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset('assets/images/logo.png')),
        SizedBox(
          width: 50,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 100.0,
                  buttonColor: homeColor,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Login",
                          style: fontWhite,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 100.0,
                  buttonColor: homeColor,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Register",
                        style: fontWhite,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    ]));
  } //portrait

  register() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => Register(),
    ));
  }

  login() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => LoginPage(),
    ));
  }
}
