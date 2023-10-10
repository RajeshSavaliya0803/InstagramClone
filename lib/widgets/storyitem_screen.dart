import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool show;

  const StoryItem(
      {Key? key,
      required this.imageUrl,
      required this.username,
      required this.show})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellowAccent, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.transparent, width: 0.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 45,
                  ),
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/2.png'),
                    radius: 45,
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/2.png'),
                    radius: 45,
                  ),
                ),
              ),
            ),
            show == false
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: 4,
                    left: 45,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          username,
          style: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
