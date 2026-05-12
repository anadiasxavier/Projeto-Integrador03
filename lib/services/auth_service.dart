import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? lastErrorMessage;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user?.sendEmailVerification();
      lastErrorMessage = null;
      return user;
    } on FirebaseAuthException catch (e) {
      lastErrorMessage = e.message;
      return null;
    } catch (e) {
      lastErrorMessage = 'Erro ao cadastrar. Tente novamente.';
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      lastErrorMessage = null;
      return result.user;
    } on FirebaseAuthException catch (e) {
      lastErrorMessage = e.message;
      return null;
    } catch (e) {
      lastErrorMessage = 'Erro ao entrar. Tente novamente.';
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }
}
