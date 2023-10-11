import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instragram_app/resources/firestore_methods.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/follow_button.dart';
import 'package:instragram_app/widgets/text_field_input.dart';

int followerss = 0;
int followingg = 0;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  // bool isFollowing = false;
  int postLen = 0;
  var userData = {};
  bool isLoading = false;

  String? selectedUserId;

  int selectindex = 0;

  bool isSelected = false;

  bool? isFollowing;

  getData() async {
    if (!mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      followerss = userSnap.data()!['followers'].length;
      followingg = userSnap.data()!['following'].length;
      isSelected = userSnap
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
  void initState() {
    getData();
    if (isShowUsers) {
      setState(() {
        isShowUsers = true;
      });
    } else {
      setState(() {
        isShowUsers = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Form(
            child: TextFieldInput(
              hintText: 'Search for a user...',
              onFieldSubmitted: (String _) {
                if (isShowUsers) {
                  setState(() {
                    isShowUsers = false;
                  });
                } else {
                  setState(() {
                    isShowUsers = true;
                  });
                }
              },
              textInputType: TextInputType.emailAddress,
              textEditingController: searchController,
            ),
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'username',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userData = users[index].data();
                      final targetUserId = userData['uid'] as String;
                      isFollowing = userData['followers']?.contains(
                              FirebaseAuth.instance.currentUser!.uid) ??
                          false;
                      return users.isEmpty
                          ? const Center(
                              child: Text(
                                "No Users Availble!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            )
                          : ListTile(
                              contentPadding: const EdgeInsets.only(
                                  top: 05, left: 10, right: 10),
                              leading: CachedNetworkImage(
                                imageUrl: userData['photoUrl'] ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 25,
                                ),
                                placeholder: (context, url) =>
                                    const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/2.png',
                                  ),
                                  radius: 25,
                                ),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/2.png',
                                  ),
                                  radius: 25,
                                ),
                              ),
                              title: Text(
                                userData['username'] ?? '',
                              ),
                              trailing: FollowButton(
                                text: isFollowing! ? 'Unfollow' : 'Follow',
                                backgroundColor:
                                    isFollowing! ? Colors.white : Colors.blue,
                                textColor:
                                    isFollowing! ? Colors.black : Colors.white,
                                borderColor:
                                    isFollowing! ? Colors.grey : Colors.blue,
                                function: () async {
                                  if (isFollowing!) {
                                    await FireStoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      targetUserId,
                                    );
                                  } else {
                                    await FireStoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      targetUserId,
                                    );
                                  }

                                  // Update the isFollowing state in your UI
                                  setState(() {
                                    isFollowing = !isFollowing!;
                                    if (isFollowing!) {
                                      followerss++;
                                    } else {
                                      followerss--;
                                    }
                                  });
                                },
                              ),

                              // isSelected
                              //     ? FollowButton(
                              //         text: 'Unfollow',
                              //         backgroundColor: Colors.white,
                              //         textColor: Colors.black,
                              //         borderColor: Colors.grey,
                              //         function: () async {
                              //           await FireStoreMethods().followUser(
                              //             FirebaseAuth.instance.currentUser!.uid,
                              //             targetUserId,
                              //           );

                              //           setState(() {
                              //             selectedUserId = null;
                              //             followingg--;
                              //           });
                              //         },
                              //       )
                              //     : FollowButton(
                              //         text: 'Follow',
                              //         backgroundColor: Colors.blue,
                              //         textColor: Colors.white,
                              //         borderColor: Colors.blue,
                              //         function: () async {
                              //           await FireStoreMethods().followUser(
                              //             FirebaseAuth.instance.currentUser!.uid,
                              //             targetUserId,
                              //           );

                              //           setState(() {
                              //             selectedUserId = targetUserId;
                              //             followingg++;
                              //           });
                              //         },
                              //       ),
                              // onTap: () {
                              //   setState(() {
                              //     if (isSelected) {
                              //       selectedUserId = null;
                              //     } else {
                              //       selectedUserId = targetUserId;
                              //       isSelected = true;
                              //     }
                              //   });
                              // },

                              //  isFollowing == false
                              //     ? FollowButton(
                              //         text: 'Follow',
                              //         backgroundColor: Colors.blue,
                              //         textColor: Colors.white,
                              //         borderColor: Colors.blue,
                              //         function: () async {
                              //           await FireStoreMethods().followUser(
                              //             FirebaseAuth.instance.currentUser!.uid,
                              //             targetUserId,
                              //           );

                              //           setState(() {
                              //             isFollowing = true;
                              //             followerss++;
                              //           });
                              //         },
                              //       )
                              //     : FollowButton(
                              //         text: 'Unfollow',
                              //         backgroundColor: Colors.white,
                              //         textColor: Colors.black,
                              //         borderColor: Colors.grey,
                              //         function: () async {
                              //           await FireStoreMethods().followUser(
                              //             FirebaseAuth.instance.currentUser!.uid,
                              //             targetUserId,
                              //           );

                              //           setState(() {
                              //             isFollowing = false;
                              //             followerss--;
                              //           });
                              //         },
                              //       ),
                              // FollowButton(
                              //   text: isFollowing ? 'Unfollow' : 'Follow',
                              //   backgroundColor: isFollowing ? Colors.white : Colors.blue,
                              //   textColor: isFollowing ? Colors.black : Colors.white,
                              //   borderColor: isFollowing ? Colors.grey : Colors.blue,
                              //   function: () async {
                              //     if (isFollowing) {
                              //       await FireStoreMethods().followUser(
                              //         FirebaseAuth.instance.currentUser!.uid,
                              //         targetUserId,
                              //       );
                              //     } else {
                              //       await FireStoreMethods().followUser(
                              //         FirebaseAuth.instance.currentUser!.uid,
                              //         targetUserId,
                              //       );
                              //     }

                              //     setState(() {
                              //       isFollowing = !isFollowing;
                              //       if (isFollowing) {
                              //         followerss++;
                              //       } else {
                              //         followerss--;
                              //       }
                              //     });
                              //   },
                              // ),
                            );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: MasonryGridView.count(
                      crossAxisCount: 3,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl: snapshot.data!.docs[index]['postUrl'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/2.png',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                    ),
                  );
                },
              )
        // isShowUsers
        //     ? FutureBuilder(
        //         future: FirebaseFirestore.instance
        //             .collection('users')
        //             .where(
        //               'username',
        //               isGreaterThanOrEqualTo: searchController.text,
        //             )
        //             .get(),
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return const Center(
        //               child: CircularProgressIndicator(),
        //             );
        //           } else if (snapshot.hasError) {
        //             return const Center(
        //               child: Text('Error loading data'),
        //             );
        //           }

        //           final users = snapshot.data!.docs;

        //           return ListView.builder(
        //             itemCount: users.length,
        //             itemBuilder: (context, index) {
        //               final userData = users[index].data();
        //               final targetUserId = userData['uid'] as String;
        //               var isFollowing = userData['followers']
        //                   .contains(FirebaseAuth.instance.currentUser!.uid);
        //               return users.isEmpty
        //                   ? const Center(
        //                       child: Text(
        //                         "No Users Availble!",
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.w500,
        //                             fontSize: 20),
        //                       ),
        //                     )
        //                   : ListTile(
        //                       contentPadding: const EdgeInsets.only(
        //                           top: 05, left: 10, right: 10),
        //                       leading: CachedNetworkImage(
        //                         imageUrl: userData['photoUrl'] ?? '',
        //                         imageBuilder: (context, imageProvider) =>
        //                             CircleAvatar(
        //                           backgroundImage: imageProvider,
        //                           radius: 25,
        //                         ),
        //                         placeholder: (context, url) =>
        //                             const CircularProgressIndicator(),
        //                         errorWidget: (context, url, error) =>
        //                             const CircleAvatar(
        //                           backgroundImage: NetworkImage(
        //                               'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg'),
        //                           radius: 25,
        //                         ),
        //                       ),
        //                       title: Text(
        //                         userData['username'] ?? '',
        //                       ),
        //                       trailing: FollowButton(
        //                         text: isFollowing ? 'Unfollow' : 'Follow',
        //                         backgroundColor:
        //                             isFollowing ? Colors.white : Colors.blue,
        //                         textColor:
        //                             isFollowing ? Colors.black : Colors.white,
        //                         borderColor:
        //                             isFollowing ? Colors.grey : Colors.blue,
        //                         function: () async {
        //                           if (isFollowing) {
        //                             await FireStoreMethods().followUser(
        //                               FirebaseAuth.instance.currentUser!.uid,
        //                               targetUserId,
        //                             );
        //                           } else {
        //                             await FireStoreMethods().followUser(
        //                               FirebaseAuth.instance.currentUser!.uid,
        //                               targetUserId,
        //                             );
        //                           }

        //                           // Update the isFollowing state in your UI
        //                           setState(() {
        //                             isFollowing = !isFollowing;
        //                             if (isFollowing) {
        //                               followerss++;
        //                             } else {
        //                               followerss--;
        //                             }
        //                           });
        //                         },
        //                       ),

        //                       // isSelected
        //                       //     ? FollowButton(
        //                       //         text: 'Unfollow',
        //                       //         backgroundColor: Colors.white,
        //                       //         textColor: Colors.black,
        //                       //         borderColor: Colors.grey,
        //                       //         function: () async {
        //                       //           await FireStoreMethods().followUser(
        //                       //             FirebaseAuth.instance.currentUser!.uid,
        //                       //             targetUserId,
        //                       //           );

        //                       //           setState(() {
        //                       //             selectedUserId = null;
        //                       //             followingg--;
        //                       //           });
        //                       //         },
        //                       //       )
        //                       //     : FollowButton(
        //                       //         text: 'Follow',
        //                       //         backgroundColor: Colors.blue,
        //                       //         textColor: Colors.white,
        //                       //         borderColor: Colors.blue,
        //                       //         function: () async {
        //                       //           await FireStoreMethods().followUser(
        //                       //             FirebaseAuth.instance.currentUser!.uid,
        //                       //             targetUserId,
        //                       //           );

        //                       //           setState(() {
        //                       //             selectedUserId = targetUserId;
        //                       //             followingg++;
        //                       //           });
        //                       //         },
        //                       //       ),
        //                       // onTap: () {
        //                       //   setState(() {
        //                       //     if (isSelected) {
        //                       //       selectedUserId = null;
        //                       //     } else {
        //                       //       selectedUserId = targetUserId;
        //                       //       isSelected = true;
        //                       //     }
        //                       //   });
        //                       // },

        //                       //  isFollowing == false
        //                       //     ? FollowButton(
        //                       //         text: 'Follow',
        //                       //         backgroundColor: Colors.blue,
        //                       //         textColor: Colors.white,
        //                       //         borderColor: Colors.blue,
        //                       //         function: () async {
        //                       //           await FireStoreMethods().followUser(
        //                       //             FirebaseAuth.instance.currentUser!.uid,
        //                       //             targetUserId,
        //                       //           );

        //                       //           setState(() {
        //                       //             isFollowing = true;
        //                       //             followerss++;
        //                       //           });
        //                       //         },
        //                       //       )
        //                       //     : FollowButton(
        //                       //         text: 'Unfollow',
        //                       //         backgroundColor: Colors.white,
        //                       //         textColor: Colors.black,
        //                       //         borderColor: Colors.grey,
        //                       //         function: () async {
        //                       //           await FireStoreMethods().followUser(
        //                       //             FirebaseAuth.instance.currentUser!.uid,
        //                       //             targetUserId,
        //                       //           );

        //                       //           setState(() {
        //                       //             isFollowing = false;
        //                       //             followerss--;
        //                       //           });
        //                       //         },
        //                       //       ),
        //                       // FollowButton(
        //                       //   text: isFollowing ? 'Unfollow' : 'Follow',
        //                       //   backgroundColor: isFollowing ? Colors.white : Colors.blue,
        //                       //   textColor: isFollowing ? Colors.black : Colors.white,
        //                       //   borderColor: isFollowing ? Colors.grey : Colors.blue,
        //                       //   function: () async {
        //                       //     if (isFollowing) {
        //                       //       await FireStoreMethods().followUser(
        //                       //         FirebaseAuth.instance.currentUser!.uid,
        //                       //         targetUserId,
        //                       //       );
        //                       //     } else {
        //                       //       await FireStoreMethods().followUser(
        //                       //         FirebaseAuth.instance.currentUser!.uid,
        //                       //         targetUserId,
        //                       //       );
        //                       //     }

        //                       //     setState(() {
        //                       //       isFollowing = !isFollowing;
        //                       //       if (isFollowing) {
        //                       //         followerss++;
        //                       //       } else {
        //                       //         followerss--;
        //                       //       }
        //                       //     });
        //                       //   },
        //                       // ),
        //                     );
        //             },
        //           );
        //         },
        //       )
        //     : FutureBuilder(
        //         future: FirebaseFirestore.instance
        //             .collection('posts')
        //             .orderBy('datePublished')
        //             .get(),
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return const Center(
        //               child: CircularProgressIndicator(),
        //             );
        //           } else if (snapshot.hasError) {
        //             return const Center(
        //               child: Text('Error loading data'),
        //             );
        //           }
        //           return Container();
        //           // Your MasonryGridView code here
        //         },
        //       ),
        );
  }
}
