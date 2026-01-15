import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User? user;
  String role = 'user';
  String name = 'User';

  bool get isAdmin => role == 'admin';

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((newUser) {
      user = newUser;
      if (newUser != null) {
        getUserData(newUser.uid);
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> getUserData(String uid) async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      role = doc.data()?['role'] ?? 'user';
      name = doc.data()?['name'] ?? 'User';
      notifyListeners();
    }
  }

  Future<String?> signUp(
    String email,
    String password,
    String nameInput,
  ) async {
    try {
      var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(res.user!.uid)
          .set({
            'uid': res.user!.uid,
            'email': email,
            'name': nameInput,
            'role': 'user',
          });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateName(String newName) async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'name': newName,
    });
    name = newName;
    notifyListeners();
  }

  void signOut() => FirebaseAuth.instance.signOut();
}
