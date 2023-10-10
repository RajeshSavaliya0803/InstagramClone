import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instragram_app/screens/profile_screen.dart';
import 'package:instragram_app/utils/colors.dart';

class FollowCard extends StatefulWidget {
  final snap;

  const FollowCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  List<dynamic> followList = [];
  List<dynamic> followers = [];
  bool isDataLoaded = false;

  getdata() async {
    if (!isDataLoaded) {
      final currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<String> followIds =
          List.from(currentUserSnapshot.data()!['followers']);

      for (int i = 0; i < followIds.length; i++) {
        var followId = followIds[i];
        var data = await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .get();

        followers.add(data);
      }
      setState(() {
        followList = followers;
        isDataLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: followList.length,
        itemBuilder: (context, index) {
          return followList.isEmpty
              ? const Center(
                  child: Text(
                    "No Followers Yet!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                )
              : Container(
                  height: 80,
                  width: double.infinity,
                  color: mobileBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: followList[index]['photoUrl'] ?? '',
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 25,
                                  ),
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/2.png'),
                                    radius: 25,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/2.png'),
                                    radius: 25,
                                  ),
                                ),
                                const SizedBox(width: 05),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                uid: followList[index]
                                                    ['uid'])));
                                  },
                                  child: Text(
                                    followList[index]['username'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
