import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/widgets/post_card.dart';

class SaveAspostScreen extends StatefulWidget {
  const SaveAspostScreen({super.key});

  @override
  State<SaveAspostScreen> createState() => _SaveAspostScreenState();
}

class _SaveAspostScreenState extends State<SaveAspostScreen> {
  Stream<QuerySnapshot> postStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('datePublished', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: postStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No posts available.');
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.hasData) {
                  DocumentSnapshot post = snapshot.data!.docs[index];
                  Map<String, dynamic> postData =
                      post.data() as Map<String, dynamic>;

                  if (postData.containsKey('isBookmarked') &&
                      postData['isBookmarked'] == true) {
                    return PostCard(
                      snap: postData,
                      index: index,
                    );
                  }
                  // else {
                  //   return SizedBox(
                  //     height: MediaQuery.of(context).size.height / 1,
                  //     child: const Center(
                  //       child: Text(
                  //         "No Bookmarked Posts!",
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }
                } else {
                  return const Text('No posts available.');
                }
              });
        },
      ),
    );
  }
}
