import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  User? user = FirebaseAuth.instance.currentUser;

  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap.data()['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' ${widget.snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: handleLikeComment,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleLikeComment() {
    setState(() {
      isLiked = !isLiked;
    });

    final commentRef =
        FirebaseFirestore.instance.collection('comments').doc(widget.snap.id);

    commentRef.get().then((doc) {
      if (doc.exists) {
        if (isLiked) {
          commentRef.update({
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([user?.uid]),
          });
        } else {
          commentRef.update({
            'likes': FieldValue.increment(-1),
            'likedBy': FieldValue.arrayRemove([user?.uid]),
          });
        }
      } else {
        print("Comment Document not found");
      }
    }).catchError((error) {
      print("Error: $error");
    });
  }
}
