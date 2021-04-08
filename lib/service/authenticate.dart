import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class DbFire {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  dynamic erroMessage = '';
  dynamic errorCode = '';

  Future createUser(String emailController, String nameController,
      String passwordController) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: emailController, password: passwordController);
      User? user = userCredential.user;
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        print('user added');
        currentUser.updateProfile(displayName: nameController);
      } else {
        throw PlatformException(
            code: errorCode, message: erroMessage as String);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future signIn(String emailController, String passwordController) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: emailController, password: passwordController);
      User? user = userCredential.user;
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        print('igned in');
      } else {
        throw PlatformException(
            code: errorCode, message: erroMessage as String);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future signout() async {
    await firebaseAuth.signOut();
  }
}
