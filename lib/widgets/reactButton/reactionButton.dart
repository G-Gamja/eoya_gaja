import 'package:flutter/material.dart';
import 'items/item.dart';
import 'data/example_data.dart' as Example;

class EmojiReactionButton extends StatefulWidget {
  EmojiReactionButton({Key? key}) : super(key: key);

  @override
  State<EmojiReactionButton> createState() => _EmojiReactionButtonState();
}

class _EmojiReactionButtonState extends State<EmojiReactionButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (_) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 5),
            children: [
              Item(
                'image 1',
                'assets/images/img1.jpg',
                Example.reactions,
              ),
              Item(
                'image 2',
                'assets/images/img2.jpg',
                Example.reactions,
              ),
              Item(
                'image 3',
                'assets/images/img3.jpg',
                Example.reactions,
              ),
              Item(
                'image 4',
                'assets/images/img4.jpg',
                Example.reactions,
              ),
              Item(
                'image 5',
                'assets/images/img5.jpg',
                Example.reactions,
              ),
            ],
          );
        },
      ),
    );
  }
}
