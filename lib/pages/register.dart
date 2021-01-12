import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_secure/model/authentication.dart';
import 'package:home_secure/model/firestore-services.dart';
import 'package:home_secure/model/user.dart';
import 'package:home_secure/pages/login-page.dart';
import 'package:home_secure/utilities/constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
  } //Widget build

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.backspace),
          hoverColor: googleColor,
          onPressed: () {
            backToLogin();
          },
        ),
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
                    SizedBox(height: 10),
                    inputContainer(
                        _nameController,
                        validateName,
                        TextInputType.text,
                        "Enter your Full Name",
                        Icons.person_outline,
                        false),
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
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: buttonContainer(
                          splashColor, "Register", register, colorWhite),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          color: colorWhite,
          onPressed: () {
            backToLogin();
          },
        ),
        title: Text(
          'Register',
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
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    inputContainer(
                        _nameController,
                        validateName,
                        TextInputType.text,
                        "Enter your Full Name",
                        Icons.person_outline,
                        false),
                    SizedBox(
                      height: 3,
                    ),
                    inputContainer(
                        _emailController,
                        validateEmail,
                        TextInputType.emailAddress,
                        "Enter your Email Address",
                        Icons.mail,
                        false),
                    SizedBox(
                      height: 3,
                    ),
                    inputContainer(
                        _passwordController,
                        validatePassword,
                        TextInputType.text,
                        "Enter your Password",
                        Icons.lock,
                        true),
                    Padding(
                      padding: EdgeInsets.only(left: 110),
                      child: buttonContainer(
                          splashColor, "Register", register, colorWhite),
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
  //generate random id

  ///////////////////////////////////////////////////function//////////////////////////////////////////
  register() async {
    Authentication authen = Authentication();
    if (_formKey.currentState.validate()) {
      //form fields are validated
      _formKey.currentState.save();
      /* start of generating a random id */
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();
      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      /* End of generating a random id */
      //using the method from the authentication page
      final checkUser = await authen.registerMethod(
          _emailController.text.trim(), _passwordController.text.trim());

      if (checkUser) {
        print('check user is.................................$checkUser');

        //means registration was successful
        var id = getRandomString(30);
        UserModel newUser = new UserModel(
            id: id, name: _nameController.text, email: _emailController.text);
        //add user details to database
        await FirestoreService().addUser(newUser);
        //head back to login page
        backToLogin();
        //display a message
        displayMsg('Registration was Successful');
      }
    } else {
      setState(() {
        _validate = true;
        displayMsg('Please fill the form correctly');
      });
    }
  }

  backToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => LoginPage(),
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

  String validateName(String value) {
    String pattern = '(^[a-zA-Z ])';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    } else if (value.length < 6) {
      return "Your Full Name is too short, Please ensure you enter your First Name and Last Name and it must at least three characters";
    }
    return null;
  } //

  String validatePhone(String value) {
    if (value.length == 0) {
      return "A Valid Phone Number  is Required";
    } else if (value.length < 11) {
      return "Your Phone Number is not complete, it must at least eleven characters";
    }
    return null;
  } //val

} //RegisterState
