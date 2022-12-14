import 'cached_circle_avatar.dart';

import '../themes/text_styles.dart';

import '../models/funding_item.dart';
import '../pages/item_details_page.dart';
import 'crypto_progress_indicator.dart';
import 'glass_container.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FundingCard extends StatelessWidget {
  final FundingItem fundingItem;

  const FundingCard({
    Key? key,
    required this.fundingItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fundingItem.creator,
                style: TextStyles.titleSmall,
              ),
              Text(
                timeago.format(fundingItem.whenAdded),
                style: TextStyles.titleSmall,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 8.0),
          child: GlassContainer(
            width: double.infinity,
            height: deviceHeight * 0.165,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedCircleAvatar(
                    size: 96,
                    radius: 48,
                    image: fundingItem.image,
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fundingItem.name,
                        style: TextStyles.titleSmall,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${fundingItem.price}\$',
                        style: TextStyles.bodyMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CryptoProgressIndicator(
                        width: deviceWidth * 0.43,
                        fundingItem: fundingItem,
                        baseColor: const Color.fromARGB(255, 86, 94, 103),
                        highlightColor:
                            const Color.fromARGB(255, 141, 147, 154),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FundingCardProfile extends StatelessWidget {
  final FundingItem fundingItem;
  final Function deleteFunction;

  const FundingCardProfile({
    Key? key,
    required this.fundingItem,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZoomTapAnimation(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) {
                  return ItemDetailsPage(fundingItem: fundingItem);
                }),
              ),
            );
          },
          child: ListTile(
            leading: CachedCircleAvatar(
              size: 44,
              radius: 22,
              image: fundingItem.image,
            ),
            title: Text(
              fundingItem.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${fundingItem.price}\$',
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              onPressed: () {
                deleteFunction();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xff263742),
          thickness: 3,
        ),
      ],
    );
  }
}
