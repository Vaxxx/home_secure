import 'package:flutter/material.dart';
import 'package:home_secure/model/authentication.dart';
import 'package:home_secure/pages/add-neighbors.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/pages/home-page.dart';
import 'package:home_secure/pages/show-neighbours.dart';
import 'package:home_secure/pages/subscribe.dart';
import 'package:home_secure/utilities/constants.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: homeColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text('Home Secure ', style: fontWhite),
                  ),
                ],
              )),
          ListTile(
            title: Text('Subscribe'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    Subscribe(email: Dashboard.CURRENT_EMAIL),
              ));
            },
          ),
          ListTile(
            title: Text('Add Neighbours'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddNeighbors(),
              ));
            },
          ),
          ListTile(
            title: Text('Show Neighbours'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ShowNeighbours(),
              ));
            },
          ),
          Divider(color: colorDeepBlue),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              Authentication authentication = new Authentication();
              authentication.logout();
              authentication.exitUser();
            },
          ),
          ListTile(
            title: Text('Exit'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
