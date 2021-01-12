import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'contact.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String contactsTable = 'contacts_table';
  String colId = 'id';
  String colName = 'name';
  String colContact = 'contact';
  String colInitial = 'initial';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contacts.db';

    // Open/create the database at a given path
    var contactsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contactsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contactsTable(id INTEGER PRIMARY KEY, $colName TEXT, '
        '$colContact TEXT, $colInitial TEXT)');
  }

  // Fetch Operation: Get all new objects from database
  Future<List<Map<String, dynamic>>> getContactsMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $newTable order by $colPriority ASC');
    var result = await db.query(contactsTable, orderBy: '$colId ASC');
    return result;
  }

  // Future<List<ContactPerson>> getContactsList() async {
  //   var contactMapList =
  //       await getContactsMapList(); // Get 'Map List' from database
  //   int count =
  //       contactMapList.length; // Count the number of map entries in db table
  //
  //   List<ContactPerson> contactList = List<ContactPerson>();
  //   // For loop to create a 'news List' from a 'Map List'
  //   for (int i = 0; i < count; i++) {
  //     contactList.add(ContactPerson.fromJson(contactMapList[i]));
  //   }
  //   return contactList;
  // }

  // Insert Operation: Insert a new object to database
  Future<int> insertContact(ContactPerson contact) async {
    Database db = await this.database;
    var result = await db.insert(contactsTable, contact.toJson());
    return result;
  }

  // Update Operation: Update a news object and save it to database
  Future<int> updateContact(ContactPerson contact) async {
    var db = await this.database;
    var result = await db.update(contactsTable, contact.toJson(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  // Delete Operation: Delete a news object from database
  Future<int> deleteContact(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $contactsTable WHERE $colId = $id');
    return result;
  }

  // Get number of news objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $contactsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'news List' [ List<news> ]
  Future<List<ContactPerson>> getContactsList() async {
    var contactsMapList =
        await getContactsMapList(); // Get 'Map List' from database
    int count =
        contactsMapList.length; // Count the number of map entries in db table

    List<ContactPerson> contactsList = List<ContactPerson>();
    // For loop to create a 'news List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactsList.add(ContactPerson.fromJson(contactsMapList[i]));
    }
    return contactsList;
  }
}
