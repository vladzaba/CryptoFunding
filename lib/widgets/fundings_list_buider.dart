import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../models/funding_item.dart';
import '../pages/item_details_page.dart';
import '../providers/database_provider.dart';
import '../services/authentication_service.dart';
import '../services/cloud_storage_service.dart';
import '../themes/text_styles.dart';
import 'custom_dialog.dart';
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

class ProfileFundingsListBuilder extends StatelessWidget {
  final List<FundingItem> fundingsList;
  final String title;

  final CloudStorageService cloudStorage;
  final AuthenticationService auth;
  final DatabaseProvider db;

  const ProfileFundingsListBuilder({
    Key? key,
    required this.fundingsList,
    required this.title,
    required this.cloudStorage,
    required this.auth,
    required this.db,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyles.titleMedium,
          ),
        ),
        ListView.builder(
          itemCount: fundingsList.length,
          itemBuilder: ((context, index) {
            return FundingCardProfile(
              fundingItem: fundingsList[index],
              deleteFunction: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      contentText: 'Are you sure you want to delete',
                      itemName: '\n${fundingsList[index].name}',
                      actionText: 'Delete',
                      onTapFunction: () {
                        Navigator.of(context).pop();
                        db.deleteItem(fundingsList[index]);
                        cloudStorage.deleteImageFromStorage(
                          auth.uid,
                          fundingsList[index].id,
                        );
                      },
                    );
                  },
                );
              },
            );
          }),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        const SizedBox(height: 25,),
      ],
    );
  }
}
