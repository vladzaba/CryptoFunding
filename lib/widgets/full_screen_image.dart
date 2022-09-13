import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String image;

  const FullScreenImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1e2c37),
        body: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              image,
            ),
          ),
        ),
      ),
    );
  }
}