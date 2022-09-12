import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  late final FirebaseAuth auth;

  AuthenticationService() {
    auth = FirebaseAuth.instance;
  }

  String get uid {
    return auth.currentUser!.uid;
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print('Error logging user');
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      print('Error registering');
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
