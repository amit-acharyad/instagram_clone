import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String bio;
  final String userName;
  final String gender;
  late final String photoUrl;
  UserModel(
      {required this.id,
      required this.name,
      required this.userName,
      required this.gender,
      required this.bio,
      required this.photoUrl});
  static UserModel empty() =>
      UserModel(id: '', name: '',gender: '', userName: '', bio: '', photoUrl: '');
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      return UserModel(
          id: data?['id'],
          bio: data?['bio'],
          name: data?['name'],
          gender: data?['gender'],
          userName: data?['userName'],
          photoUrl: data?['photoUrl']);
    } else {
      return UserModel.empty();
    }
  }
   factory UserModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentQuerySnapshot) {
    if (documentQuerySnapshot.exists) {
      final data = documentQuerySnapshot.data();
      return UserModel(
          id: data['id'],
          bio: data['bio'],
          name: data['name'],
          gender: data['gender'],
          userName: data['userName'],
          photoUrl: data['photoUrl']);
    } else {
      return UserModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userName': userName,
      'gender':gender,
      'bio': bio,
      'photoUrl': photoUrl
    };
  }
}
