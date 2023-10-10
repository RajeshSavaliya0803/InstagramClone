import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String storyId;
  final DateTime datePublished;
  final String storyUrl;
  final String storyImage;

  const Story({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.storyId,
    required this.datePublished,
    required this.storyUrl,
    required this.storyImage,
  });

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Story(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        storyId: snapshot["storyId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        storyUrl: snapshot['storyUrl'],
        storyImage: snapshot['storyImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "storyId": storyId,
        "datePublished": datePublished,
        'storyUrl': storyUrl,
        'storyImage': storyImage
      };
}
