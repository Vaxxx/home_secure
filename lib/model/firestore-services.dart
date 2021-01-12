import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_secure/model/model-plan.dart';
import 'package:home_secure/model/user.dart';

class FirestoreService {
  //make singletion
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  FirestoreService._internal();
  Firestore _db = Firestore.instance;

  factory FirestoreService() {
    return _firestoreService;
  }

  Future<void> addUser(UserModel user) {
    return _db.collection('users').add(user.toMap());
  }

  Future<void> addSubscription(ModelPlan plan) {
    return _db.collection('subscriptions').add(plan.toMap());
  }
}
