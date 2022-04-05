import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  UserData({
    required this.firstName,
    required this.lastName,
    this.imageUrl,
    this.fireUser,
  });

  User? fireUser;
  String firstName, lastName;
  String? imageUrl;

  static UserData get empty => UserData(firstName: '', lastName: '');

  @override
  bool operator ==(Object other) =>
      (other is UserData) &&
      (fireUser?.uid ?? -1) == (other.fireUser?.uid ?? 1);

  @override
  int get hashCode => fireUser?.uid.hashCode ?? 0;

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'imageUrl': imageUrl,
      };

  UserData.fromOject(dynamic object)
      : firstName = object["firstName"],
        lastName = object["lastName"],
        imageUrl = object["imageUrl"];
}
