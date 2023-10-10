import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instragram_app/screens/add_posts_screen.dart';
import 'package:instragram_app/screens/favourite_screen.dart';
import 'package:instragram_app/screens/feed_screen.dart';
import 'package:instragram_app/screens/profile_screen.dart';
import 'package:instragram_app/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const PostScreen(),
  const FavoriteScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
