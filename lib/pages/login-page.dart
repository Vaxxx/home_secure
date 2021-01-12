import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_secure/model/authentication.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/pages/register.dart';
import 'package:home_secure/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  static String EMAIL = '';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    //sign in user
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait();
    } else {
      return landscape();
    }
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          textAlign: TextAlign.center,
        ),
        backgroundColor: homeColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //////////////////////////////////////ITEM 1 //////////////////////////////////////////////////////////
              //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
              Form(
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    inputContainer(
                        _emailController,
                        validateEmail,
                        TextInputType.emailAddress,
                        "Enter your Email Address",
                        Icons.mail,
                        false),
                    inputContainer(
                        _passwordController,
                        validatePassword,
                        TextInputType.text,
                        "Enter your Password",
                        Icons.lock,
                        true),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(left: 30),
                        //   child: buttonContainer(
                        //       googleColor,
                        //       "Login with Google",
                        //       loginWithGoogle(),
                        //       colorWhite),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: buttonContainer(
                              splashColor, "Login", login, colorWhite),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: buttonContainer(
                              colorWhite, "Registered?", register, homeColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  Widget portrait() {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //////////////////////////////////////ITEM 1 //////////////////////////////////////////////////////////
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                  ),
                ),
              ),

              //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
              Form(
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    inputContainer(
                        _emailController,
                        validateEmail,
                        TextInputType.emailAddress,
                        "Enter your Email Address",
                        Icons.mail,
                        false),
                    inputContainer(
                        _passwordController,
                        validatePassword,
                        TextInputType.text,
                        "Enter your Password",
                        Icons.lock,
                        true),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        // buttonContainer(googleColor, "Login with Google",
                        //     loginWithGoogle(), colorWhite),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 30),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       loginWithGoogle();
                        //     },
                        //     child: Container(
                        //         width: 200,
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //             image: DecorationImage(
                        //                 image: googleImage,
                        //                 fit: BoxFit.cover))),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: buttonContainer(
                              colorWhite, "Registered?", register, homeColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        buttonContainer(
                            splashColor, "Login", login, colorWhite),
                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    if (_formKey.currentState.validate()) {
      //form fields are validated
      _formKey.currentState.save();
      //final checkUser = await loginMethod(
      //   _emailController.text.trim(), _passwordController.text.trim());
      try {
        final checkUser = await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        LoginPage.EMAIL = _emailController.text.trim();
        if (checkUser != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(
              email: _emailController.text.trim(),
            ),
          ));
        }
      } catch (e) {
        displayMsg('Wrong Values inserted');
      }
    } else {
      setState(() {
        _validate = true;
        displayMsg('Please fill the form correctly');
      });
    }
  }

  logout() {}

  loginWithGoogle() {
    Authentication authen = Authentication();
    print('The correct eamil address is: ${Authentication.MAIL}');
    authen.googleSignInMethod().whenComplete(
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Dashboard(
                  email: Authentication.MAIL,
                ))));
  }

  register() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => Register(),
    ));
  }

  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  } //validateEmail

  String validatePassword(String value) {
    if (value.length == 0) {
      return "A Password  is Required";
    } else if (value.length < 5) {
      return "Your Password is too short, it must at least five characters";
    }
    return null;
  }
}
