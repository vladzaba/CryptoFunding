import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDetails extends StatelessWidget {
  const ShimmerDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xff263742),
        highlightColor: const Color.fromARGB(255, 55, 76, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  radius: 64,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Container(
                      width: 150,
                      height: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 80,
                      height: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 170,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 380,
              height: 15,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 170,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 380,
              height: 15,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 110,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: deviceWidth * 0.92,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              height: 15,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              height: 15,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 170,
              height: 15,
              color: Colors.white,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 160,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(
              height: 8,
            ),
            shimmerTransaction(),
            const SizedBox(
              height: 8,
            ),
            shimmerTransaction(),
            const SizedBox(
              height: 8,
            ),
            shimmerTransaction(),
          ],
        ),
      ),
    );
  }

  Widget shimmerTransaction() {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 14,
              ),
              Container(
                width: 80,
                height: 15,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            width: 500,
            height: 75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCryptoProgressIndicator extends StatelessWidget {
  final double width;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerCryptoProgressIndicator({
    Key? key,
    required this.width,
    required this.baseColor,
    required this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Center(
            child: Container(
              width: width,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
