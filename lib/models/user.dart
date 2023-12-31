import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final bool? issave;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.issave,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data();

    if (snapshot is Map<String, dynamic>) {
      return User(
        username: snapshot["username"] ?? "",
        uid: snapshot["uid"] ?? "",
        email: snapshot["email"] ?? "",
        photoUrl: snapshot["photoUrl"] ?? "",
        bio: snapshot["bio"] ?? "",
        followers: snapshot["followers"] ?? [],
        following: snapshot["following"] ?? [],
        issave: snapshot["issave"] ?? [],
      );
    } else {
      return const User(
          username: "",
          uid: "",
          email: "",
          photoUrl: "",
          bio: "",
          followers: [],
          following: [],
          issave: false);
    }
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "issave": issave,
      };
}
