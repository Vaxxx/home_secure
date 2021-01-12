import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_secure/model/contact.dart';
import 'package:home_secure/model/database-helper.dart';
import 'package:home_secure/pages/add-neighbors.dart';
import 'package:home_secure/utilities/constants.dart';
import 'package:home_secure/widgets/nav-drawer.dart';
import 'package:sms/sms.dart';
import 'package:sqflite/sqflite.dart';

class Dashboard extends StatefulWidget {
  final String email;
  static String CURRENT_EMAIL = '';
  const Dashboard({Key key, @required this.email}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String currentEmail = '';
  final firestoreInstance = Firestore.instance;
  bool isSubscribed = false; // to determine the subscription

  DatabaseHelper helper = DatabaseHelper();
  List<ContactPerson> contactsList;
  int count = 0;

  void _setTargetPlatformForDesktop() {
    TargetPlatform targetPlatform;
    if (Platform.isMacOS) {
      targetPlatform = TargetPlatform.iOS;
    } else if (Platform.isLinux || Platform.isWindows) {
      targetPlatform = TargetPlatform.android;
    }
    if (targetPlatform != null) {
      debugDefaultTargetPlatformOverride = targetPlatform;
    }
  }

  @override
  void initState() {
    Dashboard.CURRENT_EMAIL = widget.email;
    currentEmail = widget.email;
    _setTargetPlatformForDesktop();
    checkSubscription();

    updateListView();
    super.initState();
    // getCurrentEmail();
    // print("The current mail is $currentEmail");
    // print('The authentication mail is ${Authentication.MAIL}');
    // print('The Login Page email is ${LoginPage.EMAIL}');
    // print('The home page email is ${HomePage.HOME_EMAIL}');
  }

  // getCurrentEmail() {
  //   setState(() {
  //     if (HomePage.HOME_EMAIL != null) {
  //       currentEmail = HomePage.HOME_EMAIL;
  //     } else if (Authentication.MAIL != null) {
  //       print('The authentication mail is ${Authentication.MAIL}');
  //       currentEmail = Authentication.MAIL;
  //     } else {
  //       currentEmail = LoginPage.EMAIL;
  //     }
  //   });
  // }

  checkSubscription() {
    print('Notgetttttttttttttttttttttttttttttttttttttttttttttttttt');
    print('Current Mail:..................$currentEmail');
    firestoreInstance
        .collection("subscriptions")
        .where("email", isEqualTo: currentEmail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((result) {
        print('the result is now.............................');

        print(result.data);
        print("The result values are : ${result.data.values}");
        print(
            "The result values emptiness are : ${result.data.values.isEmpty}");
        print("The result values length are : ${result.data.values.length}");
        print(
            "The result values element at 0 are : ${result.data.values.elementAt(0)}");
        print(
            "The result values element at 1 are : ${result.data.values.elementAt(1)}");
        print(
            "The result values non emptiness are : ${result.data.values.isNotEmpty}");
        print("The result keys are : ${result.data.keys}");
        if (result.data.values.elementAt(0) == 'Monthly' ||
            result.data.values.elementAt(0) == 'Quarterly' ||
            result.data.values.elementAt(0) == 'Yearly') {
          print('result is not empty o');
          //show help image
          setState(() {
            isSubscribed = true;
          });
        } else {
          print('result is actually empty!');
          //show disabled help image
          setState(() {
            isSubscribed = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: homeColor,
        title: Text(
          'Home Secure',
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: colorWhite,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddNeighbors(),
              ));
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: mainBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  help();
                },
                child: isSubscribed
                    ? GestureDetector(
                        onTap: () {
                          help();
                        },
                        child: helpImage,
                      )
                    : GestureDetector(
                        onTap: () {
                          displayMsg(
                              "YOU MUST BE SUBSCRIBED TO CALL FOR HELP!");
                        },
                        child: unSubscribedImage,
                      )),
          )
        ],
      ),
    );
  }

  help() {
    print('help 0!');
    for (int i = 0; i < contactsList.length; i++) {
      print("The total contact present include: ${contactsList[i].contact}");

      SmsSender sender = new SmsSender();
      String address = contactsList[i].contact;

      SmsMessage message = new SmsMessage(
          address, 'This is a request for help. Please call the police!');
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });
      sender.sendSms(message);
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ContactPerson>> noteListFuture = helper.getContactsList();
      noteListFuture.then((contactsList) {
        setState(() {
          this.contactsList = contactsList;
          this.count = contactsList.length;
        });
      });
    });
  }
}
