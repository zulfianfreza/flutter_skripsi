import 'package:firebase_auth/firebase_auth.dart';
import 'package:skripsi/models/user_model.dart';
import 'package:skripsi/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required int age,
    required int height,
    required int weight,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
      );

      await UserService().setUser(user);

      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
