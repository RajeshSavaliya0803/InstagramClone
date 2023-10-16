import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instragram_app/resources/firestore_methods.dart';
import 'package:instragram_app/screens/follow_screen.dart';
import 'package:instragram_app/screens/following_screen.dart';
import 'package:instragram_app/screens/login_screen.dart';
import 'package:instragram_app/screens/menu/setting_privacy_screen.dart';
import 'package:instragram_app/screens/save_posts_screen.dart';
import 'package:instragram_app/screens/search_screen.dart';
import 'package:instragram_app/screens/update_profile_screen.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/follow_button.dart';
import 'package:instragram_app/models/user.dart' as model;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  final List<IconData> starIcons = [
    Icons.settings,
    Icons.alternate_email_outlined,
    Icons.browse_gallery_rounded,
    Icons.archive,
    Icons.qr_code_scanner_rounded,
    Icons.bookmark_outlined,
    Icons.supervisor_account,
    Icons.credit_card,
    Icons.merge_type_rounded,
    Icons.close_fullscreen_sharp,
    Icons.favorite_outline_outlined,
  ];

  final List iteam = [
    "Settings and privacy",
    "Threads",
    "Your activity",
    "Archive",
    "QR code",
    "Saved",
    "Supervision",
    "Orders and payments",
    "Meta Veriffied",
    "Close fiends",
    "Favourites"
  ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  getData() async {
    if (!mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = followerss ?? userSnap.data()!['followers'].length;
      following = followingg ?? userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'] ?? '',
              ),
              centerTitle: false,
              actions: [
                GestureDetector(
                    onTap: () {
                      openBottomSheet(context);
                    },
                    child: const Icon(Icons.menu, color: Colors.white)),
                const SizedBox(width: 15)
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: userData['photoUrl'] ?? '',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 45,
                            ),
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/2.png'),
                              radius: 45,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/2.png'),
                              radius: 45,
                            ),
                          ),
                          // Stack(
                          //   children: [
                          //     CachedNetworkImage(
                          //       imageUrl: userData['photoUrl'] ?? '',
                          //       imageBuilder: (context, imageProvider) =>
                          //           CircleAvatar(
                          //         backgroundImage: imageProvider,
                          //         radius: 45,
                          //       ),
                          //       placeholder: (context, url) =>
                          //           const CircleAvatar(
                          //         backgroundImage:
                          //             AssetImage('assets/images/2.png'),
                          //         radius: 45,
                          //       ),
                          //       errorWidget: (context, url, error) =>
                          //           const CircleAvatar(
                          //         backgroundImage:
                          //             AssetImage('assets/images/2.png'),
                          //         radius: 45,
                          //       ),
                          //     ),
                          //     Positioned(
                          //       bottom: 0,
                          //       right: 0,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(context, MaterialPageRoute(
                          //             builder: (context) {
                          //               return UpdateProfileScreen(
                          //                   userimage: userData['photoUrl'],
                          //                   username: userData['username'],
                          //                   email: userData['email'],
                          //                   password: userData['password'],
                          //                   bio: userData['bio']);
                          //             },
                          //           ));
                          //         },
                          //         child: Container(
                          //           height: 30,
                          //           width: 30,
                          //           decoration: const BoxDecoration(
                          //               shape: BoxShape.circle,
                          //               color: Colors.white),
                          //           child: const Icon(
                          //             Icons.edit,
                          //             size: 15,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // CircleAvatar(
                          //   backgroundColor: Colors.grey,
                          //   backgroundImage: NetworkImage(
                          //     userData['photoUrl'] ?? '',
                          //   ),
                          //   radius: 40,
                          // ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts", () {}),
                                    buildStatColumn(followers, "followers", () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const FollowScreen();
                                        },
                                      ));
                                    }),
                                    buildStatColumn(following, "following", () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const FollowingScreen();
                                        },
                                      ));
                                    }),
                                  ],
                                ),
                                // isFollowing == false
                                //     ? FollowButton(
                                //         width: double.infinity,
                                //         text: 'Follow',
                                //         backgroundColor: Colors.blue,
                                //         textColor: Colors.white,
                                //         borderColor: Colors.blue,
                                //         function: () async {
                                //           await FireStoreMethods().followUser(
                                //             FirebaseAuth
                                //                 .instance.currentUser!.uid,
                                //             userData['uid'],
                                //           );

                                //           setState(() {
                                //             isFollowing = true;
                                //             followers++;
                                //           });
                                //         },
                                //       )
                                //     : FollowButton(
                                //         width: double.infinity,
                                //         text: 'Unfollow',
                                //         backgroundColor: Colors.white,
                                //         textColor: Colors.black,
                                //         borderColor: Colors.grey,
                                //         function: () async {
                                //           await FireStoreMethods().followUser(
                                //             FirebaseAuth
                                //                 .instance.currentUser!.uid,
                                //             userData['uid'],
                                //           );

                                //           setState(() {
                                //             isFollowing = false;
                                //             followers--;
                                //           });
                                //         },
                                //       ),
                                FollowButton(
                                  text: 'Edit Profile',
                                  width: double.infinity,
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  function: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateProfileScreen(
                                            userimage: userData['photoUrl'],
                                            username: userData['username'],
                                            email: userData['email'],
                                            password: userData['password'],
                                            bio: userData['bio']);
                                      },
                                    ));
                                  },
                                ),

                                // FollowButton(
                                //   text: 'Save Posts',
                                //   width: double.infinity,
                                //   backgroundColor: mobileBackgroundColor,
                                //   textColor: primaryColor,
                                //   borderColor: Colors.grey,
                                //   function: () {
                                //     Navigator.push(context, MaterialPageRoute(
                                //       builder: (context) {
                                //         return const SaveAspostScreen();
                                //       },
                                //     ));
                                //   },
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Expanded(
                                //       child:

                                //     ),
                                //     // FirebaseAuth.instance.currentUser!.uid ==
                                //     //         widget.uid
                                //     //     ?
                                //     // FollowButton(
                                //     //   text: 'Sign Out',
                                //     //   backgroundColor: mobileBackgroundColor,
                                //     //   textColor: primaryColor,
                                //     //   borderColor: Colors.grey,
                                //     //   function: () async {
                                //     //     await AuthMethods().signOut();
                                //     //     if (context.mounted) {
                                //     //       Navigator.of(context).pushReplacement(
                                //     //         MaterialPageRoute(
                                //     //           builder: (context) =>
                                //     //               const LoginScreen(),
                                //     //         ),
                                //     //       );
                                //     //     }
                                //     //   },
                                //     // ),
                                //     // :
                                //     // isFollowing

                                //     //     ?
                                //     Expanded(
                                //       child: FollowButton(
                                //         text: 'Unfollow',
                                //         backgroundColor: Colors.white,
                                //         textColor: Colors.black,
                                //         borderColor: Colors.grey,
                                //         function: () async {
                                //           await FireStoreMethods().followUser(
                                //             FirebaseAuth
                                //                 .instance.currentUser!.uid,
                                //             userData['uid'],
                                //           );

                                //           setState(() {
                                //             isFollowing = false;
                                //             followers--;
                                //           });
                                //         },
                                //       ),
                                //     ),
                                //     // :
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(
                                            side: BorderSide(
                                                color: Colors.white)),
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(15)),
                                    child: const Icon(Icons.add, size: 35)),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'New',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )),
                        for (int i = 0; i < 10; i++) addhelight(),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 0.8,
                  indicatorPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  controller: tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on_rounded)),
                    Tab(icon: Icon(Icons.person_pin_outlined)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return (snapshot.data! as dynamic).docs.length == 0
                              ? const Center(
                                  child: Text(
                                    "No Posts Yet!",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        (snapshot.data! as dynamic).docs[index];

                                    return GestureDetector(
                                      onLongPress: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                              'Are You Sure Post Delete?',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deletePost(snap['postId']
                                                        .toString());
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'No'),
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: snap['postUrl'] ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/images/2.png',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/2.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                      GridView.count(
                        controller: scrollController,
                        crossAxisCount: 3,
                        children: [
                          for (int i = 0; i < 9; i++)
                            Container(
                                margin: const EdgeInsets.only(right: 3, top: 3),
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Widget buildStatColumn(int num, String label, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addhelight() {
    return const Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 33,
        backgroundColor: secondaryColor,
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builderContext) {
        double bottomSheetHeight = MediaQuery.of(context).size.height / 1;
        return SizedBox(
          height: bottomSheetHeight,
          child: ListView.builder(
            itemCount: starIcons.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(starIcons[index]),
                title: Text(iteam[index]),
                onTap: () {
                  if (index == 5) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const SaveAspostScreen();
                      },
                    ));
                  } else if (index == 0) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const SettingsAndPrivacyScreen();
                      },
                    ));
                  } else if (index == 1) {
                    Navigator.pop(context);
                    launchURL();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  launchURL() async {
    const url =
        'https://play.google.com/store/search?q=threads+from+instagram&c=apps&hl=en-IN';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
