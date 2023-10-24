import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/exercise_model.dart';
class ExerciseServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String extractDateComponents(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$year-$month-$day'; // Adjust the format as needed
  }
  Future<void> addExercise() async {
    var x = Exercise(uid: extractDateComponents(DateTime.now()), date: DateTime.now());
    try {
      await firestore.collection("users").doc(auth.currentUser?.uid).collection("stats").doc(extractDateComponents(DateTime.now())).set(x.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(String index, double value,String uid) async {
    try{
      await firestore.collection("users").doc(auth.currentUser?.uid).collection("stats").doc(uid).update(
          {
            index: value,
          }
      );
    }catch(e){
      return print(e.toString());
    }
  }
  Future<bool> checkExerciseForToday() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DateTime today = DateTime.now();

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("stats")
        .doc(extractDateComponents(today)) // Convert date to Firestore-compatible format
        .get();

    return doc.exists;
  }
  Future<double> getSpecificExerciseData(String value) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DateTime today = DateTime.now();

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("stats")
        .doc(extractDateComponents(today)) // Convert date to Firestore-compatible format
        .get();

    if (doc.exists) {
      // Retrieve and return the specific exercise value (forwardFlexion in this case)
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data[value].toDouble();
    } else {
      return 0.0;
    }
  }
}
