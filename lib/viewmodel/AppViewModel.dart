import 'package:android_reviewer_flutter/model/LessonModel.dart';
import 'package:android_reviewer_flutter/model/SubjectModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/QuizModel.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = "Loading...";
  String email = "Loading...";

  // **
  //------------------------------------------ USER DETAILS ------------------------------------------
  // **
  Future<void> getUserData() async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      name = currentUser.displayName ?? "No Name";
      email = currentUser.email ?? "No Email";
    } else {
      name = "Loading...";
      email = "Loading...";
    }

    notifyListeners();
  }

  // **
  //------------------------------------------ LOGIN/REGISTER ------------------------------------------
  // **
  Future<void> registerUser(context, name, email, password) async {
    try {
      // Register user with email and password
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //save user info in firestore
      await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({'email': email, 'name': name, 'role': 'user'});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<String?> loginUser(
      BuildContext context, String email, String password) async {
    try {
      // Authenticate user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Retrieve the user's document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      // Check if the document exists and return the role
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>; // Cast data to a Map
        String role = userData['role']; // Retrieve the 'role' field

        // Print the role for debugging
        print("USER ROLE TO: " + role);

        // Store in Shared Preferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('userRole', role);

        return role; // Return the retrieved role
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error logging in: $e');
      // Handle errors (e.g., wrong password, no user found)
    }

    return null; // Return null if no role is found or an error occurs
  }

  // Future<String?> loginUser(
  //     BuildContext context, String email, String password) async {
  //   try {
  //     // Authenticate user with email and password
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //
  //     // Retrieve the user's document from Firestore
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user?.uid)
  //         .get();
  //
  //     // Check if the document exists and return the role
  //     if (userDoc.exists) {
  //       // Retrieve role from the user document
  //       var userData =
  //           userDoc.data() as Map<String, dynamic>; // Cast data to a Map
  //       String role = userData['role']; // Return the 'role' field
  //       print("USER ROLE TO:" + role);
  //       //store in shared pref
  //       SharedPreferences pref = await SharedPreferences.getInstance();
  //       await pref.setString('userRole', role);
  //
  //       return role;
  //     } else {
  //       print('User document does not exist');
  //     }
  //   } catch (e) {
  //     print('Error logging in: $e');
  //     // Handle errors (e.g., wrong password, no user found)
  //   }
  //   return null; // Return null if no role is found or an error occurs
  // }

  Future<bool> logoutUser() async {
    auth.signOut();
    return true;
  }

  // **
  //------------------------------------------ SUBJECTS ------------------------------------------
  // **
  //update subj
  Future<void> updateSubject(SubjectModel subject) async {
    await firestore
        .collection('subjects')
        .doc(subject.id)
        .update(subject.toMap());
  }

  //add new subj
  Future<void> addSubject(SubjectModel subject) async {
    await firestore.collection('subjects').add(subject.toMap());
  }

  // fetch all subjects
  Stream<List<SubjectModel>> getSubjects() {
    return firestore.collection('subjects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SubjectModel.fromDocument(doc.data(), doc.id);
      }).toList();
    });
  }

  // delete subject
  Future<void> deleteSubject(String subjectID) async {
    await firestore.collection('subjects').doc(subjectID).delete();
  }

  // **
  //------------------------------------------ LESSON ------------------------------------------
  // **

  // Fetch lessons for a specific subject
  Stream<List<LessonModel>> getLesson(String subjectID) {
    return firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('lessons')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LessonModel.fromDocument(doc.data(), doc.id);
      }).toList();
    });
  }

  //add lesson to subj
  Future<void> addLesson(String subjectID, LessonModel lesson) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('lessons')
        .add(lesson.toMap());
  }

  //update a lesson
  Future<void> updateLesson(String subjectID, LessonModel lesson) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('lessons')
        .doc(lesson.id)
        .update(lesson.toMap());
  }

  //delete lesson
  Future<void> deleteLesson(String subjectID, LessonModel lesson) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('lessons')
        .doc(lesson.id)
        .delete();
  }

// **
//------------------------------------------ QUIZ ------------------------------------------
// **
  Future<void> addQuiz(String subjectID, QuizModel quiz) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('quizzes')
        .add(quiz.toMap());
  }

// Update a quiz
  Future<void> updateQuiz(String subjectID, QuizModel quiz) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('quizzes')
        .doc(quiz.id)
        .update(quiz.toMap());
  }

// Delete a quiz
  Future<void> deleteQuiz(String subjectID, String quizID) async {
    await firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('quizzes')
        .doc(quizID)
        .delete();
  }

// Fetch quizzes for a specific lesson
  Stream<List<QuizModel>> getQuizzes(String subjectID) {
    return firestore
        .collection('subjects')
        .doc(subjectID)
        .collection('quizzes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizModel.fromDocument(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> saveScore(
      String subjectID, int score, int totalQuestions) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('scores')
        .add({
      'subjectID': subjectID,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
