import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_styled_toast/flutter_styled_toast.dart';

var primaryColor = Color(0xFF4aa0d5);
var backgroundImage = Image.asset('assets/images/bg.png');
var mainBg = ExactAssetImage('assets/images/bg.jpg');
var logoImage = Image.asset('assets/images/logo.png');
var helpImage = Image.asset('assets/images/help.png');
var unSubscribedImage = Image.asset('assets/images/unsubscribed.png');
var assetLogo = AssetImage('assets/images/logo.jpg');
var topLogo = Image.asset('assets/images/logo.png');
var googleImage = AssetImage('assets/images/google_signin_button.png');
var backgroundColor = Colors.blue;
var colorGrey = Colors.grey;
var colorGreyWithOpacity = Colors.grey.withOpacity(0.2);
var colorGreyWithOpacity6 = Colors.grey.withOpacity(0.6);
var splashColor = Color(0xFF3B5998);
var colorWhite = Colors.white;
//var googleColor = Color(0xfff32e06);
var googleColor = Color(0xffc80000);
var blueyColor = Color(0xff2d3192);
var homeColor = Color(0xff709ba1);
var colorBlack = Color(0xff000000);
var colorDeepBlue = Color(0xfff111122);

void displayMsg(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: googleColor,
      textColor: colorWhite);
}

// String facebookUrl = "https://www.facebook.com/RadioSapientia95.3FM";
// //twitter
// String twitterUrl = "https://twitter.com/Sapientia953FM";
// //email
// String emailUrl = "mailto:info@sapientia953fm.com";
// //youtube
// String youtubeUrl = "https://www.youtube.com/channel/UCgb6evGOOm6mLJ9v6TmIs7Q";
// //instagram
// String instagramUrl =
//     "https://www.instagram.com/sapientia953fm/?igshid=ja0e94l7oipn";

//text style
var fontWhite = TextStyle(
    color: colorWhite,
    fontWeight: FontWeight.w700,
    fontSize: 25,
    fontFamily: ' Alfa Slab One');

var captionFont = TextStyle(
    fontFamily: ' Alfa Slab One',
    fontSize: 21.0,
    fontWeight: FontWeight.w900,
    color: homeColor);

//..............................................................//functions.................................................................
//containers template for textboxes
Container inputContainer(
    TextEditingController controller,
    String Function(String) validator,
    TextInputType textInputType,
    String hint,
    IconData icon,
    bool obscureText) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: colorGreyWithOpacity,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    child: Row(
      children: <Widget>[
        ///First Child is the email address
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Icon(
            icon,
            color: colorGrey,
          ),
        ),
        Container(
          height: 30.0,
          width: 1.0,
          color: colorGreyWithOpacity,
          margin: EdgeInsets.only(right: 10.0),
        ),
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              labelText: hint,
              hintStyle: TextStyle(color: colorGrey)),
          keyboardType: textInputType,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
        )),

        ///second child is the password field
      ],
    ),
  );
} //container

//container template for button
Container buttonContainer(
    Color splashColor, String text, Function action, Color color) {
  return Container(
    margin: EdgeInsets.only(top: 30.0),
    padding: EdgeInsets.only(left: 20.0, right: 20.0),
    child: Row(
      children: <Widget>[
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          splashColor: splashColor,
          color: splashColor,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      fontFamily: ' Alfa Slab One'),
                ),
              ),
            ],
          ),
          onPressed: () {
            action();
          },
        )
      ],
    ),
  );
}
