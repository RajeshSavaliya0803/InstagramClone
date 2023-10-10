import 'package:flutter/material.dart';
import 'package:instragram_app/widgets/post_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favorites = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: ListView.builder(
        itemCount: likepost.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                likepost[index]['description'],
                style: const TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Remove item from favorites list when the favorite icon is pressed
                  setState(() {
                    favorites.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
