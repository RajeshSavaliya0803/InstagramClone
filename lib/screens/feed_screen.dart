import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instragram_app/screens/story_list.dart';
import 'package:instragram_app/screens/your_story.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/global_variable.dart';
import 'package:instragram_app/utils/gradient_ring_widget.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/post_card.dart';
import 'package:instragram_app/widgets/storyitem_screen.dart';

class FeedScreen extends StatefulWidget {
  final String? uid;
  const FeedScreen({Key? key, this.uid}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static String collectionDbName = 'instagram_stories_db';
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);
  var userData = {};
  bool isLoading = false;
  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    if (!mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      FirebaseFirestore.instance.collection('users').doc('userId').get();
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    if (!mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Image.asset(
                'assets/images/insta.png',
                fit: BoxFit.fill,
                height: 80,
                color: primaryColor,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const YourStoryScreen();
                        },
                      ));
                    },
                    child: StoryItem(
                      imageUrl: userData['photoUrl'] ?? '',
                      username: 'Your Story',
                      show: true,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 100,
                    // width: 100,
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic>? userData =
                                snapshot.data!.data() as Map<String, dynamic>?;
                            userData =
                                snapshot.data!.data() as Map<String, dynamic>?;
                            final username = userData!['username'] ?? '';
                            final imageUrl = userData['userimage'] ?? '';

                            return Column(
                              children: [
                                WGradientRing(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        imageUrl, // Use the fetched image URL
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 30,
                                    ),
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/2.png'),
                                      radius: 30,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/2.png'),
                                      radius: 30,
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 70,
                                //   height: 70,
                                //   decoration: BoxDecoration(
                                //     gradient: const LinearGradient(
                                //       colors: [
                                //         Colors.yellowAccent,
                                //         Colors.pinkAccent
                                //       ],
                                //       begin: Alignment.topLeft,
                                //       end: Alignment.bottomRight,
                                //     ),
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //       color: Colors.transparent,
                                //       width: 0.0,
                                //     ),
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(3.0),
                                //     child:

                                //   ),
                                // ),
                                const SizedBox(height: 5),
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Text('User not found');
                          }
                        } else {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Loading indicator while fetching data
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading posts"),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No posts Yet!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: PostCard(
                        index: index,
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> storiess = [
    {
      'imageUrl':
          'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
      'username': 'User 1',
    },
    {
      'imageUrl':
          'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg',
      'username': 'User 2',
    },
  ];
}
