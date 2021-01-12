import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPlan {
  final String email;
  final String plan;

  ModelPlan({this.email, this.plan});

  factory ModelPlan.fromDocument(DocumentSnapshot doc) {
    return ModelPlan(
      email: doc['email'],
      plan: doc['plan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "plan": plan,
    };
  }
} //user
