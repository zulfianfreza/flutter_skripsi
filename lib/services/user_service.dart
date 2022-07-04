import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsi/models/user_model.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUser(UserModel user) async {
    try {
      _userReference.doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'gender': user.gender,
        'age': user.age,
        'height': user.height,
        'weight': user.weight,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        gender: snapshot['gender'],
        age: snapshot['age'],
        height: snapshot['height'],
        weight: snapshot['weight'],
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
