import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../models/funding_item.dart';
import '../pages/item_details_page.dart';
import '../themes/text_styles.dart';
import 'funding_card.dart';

class FundingsListBuilder extends StatelessWidget {
  final List<FundingItem> fundingsList;
  final String? title;

  const FundingsListBuilder({
    Key? key,
    required this.fundingsList,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title!,
                  style: TextStyles.titleLarge,
                ),
              )
            : const SizedBox.shrink(),
        ListView.builder(
          itemCount: fundingsList.length,
          itemBuilder: ((context, index) {
            return ZoomTapAnimation(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsPage(
                      fundingItem: fundingsList[index],
                    ),
                  ),
                );
              },
              child: FundingCard(
                fundingItem: fundingsList[index],
              ),
            );
          }),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}
