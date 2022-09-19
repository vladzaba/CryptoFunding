import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'shimmer_details.dart';

class CachedCircleAvatar extends StatelessWidget {
  final double size;
  final double radius;
  final String image;

  const CachedCircleAvatar({
    Key? key,
    required this.size,
    required this.radius,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: CachedNetworkImage(
          height: size,
          width: size,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          imageUrl: image,
          placeholder: (context, url) => ShimmerCircleAvatar(radius: radius),
        ),
      ),
    );
  }
}
