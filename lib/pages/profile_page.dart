import 'package:crypto_funding_app/widgets/fundings_list_buider.dart';

import '../themes/text_styles.dart';

import '../services/authentication_service.dart';
import '../widgets/custom_dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/funding_item.dart';
import '../providers/database_provider.dart';
import '../services/cloud_storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final CloudStorageService cloudStorage = CloudStorageService();
    final AuthenticationService auth = AuthenticationService();

    var db = context.watch<DatabaseProvider>();

    List<FundingItem> userActiveItems = db.items.where((element) {
      return (element.creator == firebaseAuth.currentUser!.email &&
          element.isActive == true);
    }).toList();

    List<FundingItem> userFinishedItems = db.finishedItems.where((element) {
      return (element.creator == firebaseAuth.currentUser!.email &&
          element.isActive == false);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xff1e2c37),
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    contentText: 'Are you sure you want to logout?',
                    actionText: 'Logout',
                    onTapFunction: () {
                      auth.logout().then(
                            (value) =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            ),
                          );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: userActiveItems.isNotEmpty || userFinishedItems.isNotEmpty
          ? ListView(
              children: [
                userActiveItems.isNotEmpty
                    ? ProfileFundingsListBuilder(
                        fundingsList: userActiveItems,
                        title: 'Your Active Fundings',
                        cloudStorage: cloudStorage,
                        auth: auth,
                        db: db,
                      )
                    : const SizedBox.shrink(),
                userFinishedItems.isNotEmpty
                    ? ProfileFundingsListBuilder(
                        fundingsList: userFinishedItems,
                        title: 'Your Finished Fundings',
                        cloudStorage: cloudStorage,
                        auth: auth,
                        db: db,
                      )
                    : const SizedBox.shrink(),
              ],
            )
          : const Center(
              child: Text(
                'No items were found',
                style: TextStyles.bodyMedium,
              ),
            ),
    );
  }
}
