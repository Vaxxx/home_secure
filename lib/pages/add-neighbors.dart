import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_secure/model/contact.dart';
import 'package:home_secure/model/database-helper.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/utilities/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNeighbors extends StatefulWidget {
  @override
  _AddNeighborsState createState() => _AddNeighborsState();
}

class _AddNeighborsState extends State<AddNeighbors> {
  DatabaseHelper helper = DatabaseHelper();
  List<Contact> contacts = [];
  @override
  void initState() {
    getContacts();
    super.initState();
  }

  getContacts() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      List<Contact> _contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
      setState(() {
        contacts = _contacts;
      });
    } else {
      displayMsg("Permission was not granted!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Neighbours'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Dashboard(),
              ));
            },
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(contact.initials()),
                  ),
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.elementAt(0).value),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: homeColor,
                    ),
                    onPressed: () {
                      addNeighbour(
                          contact.displayName,
                          contact.phones.elementAt(0).value,
                          contact.initials());
                    },
                  ),
                  onTap: () => addNeighbour(contact.displayName,
                      contact.phones.elementAt(0).value, contact.initials()),
                );
              }),
        ));
  }

  addNeighbour(String name, String phone, String initial) async {
    print('Name is $name and Phone is $phone');
    try {
      ContactPerson contact =
          new ContactPerson(name: name, contact: phone, initial: initial);
      await helper.insertContact(contact);
      displayMsg('Contact added Successfully!');
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
