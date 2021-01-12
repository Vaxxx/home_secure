import 'package:flutter/material.dart';
import 'package:home_secure/model/contact.dart';
import 'package:home_secure/model/database-helper.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/utilities/constants.dart';
import 'package:sqflite/sqflite.dart';

class ShowNeighbours extends StatefulWidget {
  @override
  _ShowNeighboursState createState() => _ShowNeighboursState();
}

class _ShowNeighboursState extends State<ShowNeighbours> {
  DatabaseHelper helper = DatabaseHelper();
  List<ContactPerson> contactList;
  int count = 0;

  @override
  void initState() {
    if (contactList == null) {
      contactList = List<ContactPerson>();
      updateListView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Neighbours'),
          backgroundColor: homeColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Dashboard(),
              ));
            },
          ),
        ),
        body: getContactsListUI());
  }

  ListView getContactsListUI() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: colorWhite,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(this.contactList[position].initial),
              ),
              title: Text(this.contactList[position].name),
              subtitle: Text(this.contactList[position].contact),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever),
                color: homeColor,
                onPressed: () {
                  deleteContact(this.contactList[position].id);
                },
              ),
            ),
          );
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ContactPerson>> noteListFuture = helper.getContactsList();
      noteListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }

  deleteContact(int id) async {
    //delete contact
    await helper.deleteContact(id);
    displayMsg("Contact deleted successfully");
    //navigate to the same page after contact has been deleted
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ShowNeighbours(),
    ));
  }
}
