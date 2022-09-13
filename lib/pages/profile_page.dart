import '../services/authentication_service.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/funding_card.dart';
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

    List<FundingItem> fundingList = db.items.where((element) {
      return element.creator == firebaseAuth.currentUser!.email;
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
        backgroundColor: const Color(0xff263742),
        elevation: 0.0,
      ),
      body: fundingList.isNotEmpty
          ? ListView.builder(
              itemCount: fundingList.length,
              itemBuilder: ((context, index) {
                return FundingCardProfile(
                  fundingItem: fundingList[index],
                  deleteFunction: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          contentText: 'Are you sure you want to delete',
                          itemName: '\n${fundingList[index].name}',
                          actionText: 'Delete',
                          onTapFunction: () {
                            Navigator.of(context).pop();
                            db.deleteItem(fundingList[index]);
                            cloudStorage.deleteImageFromStorage(
                                auth.uid, fundingList[index].id);
                          },
                        );
                      },
                    );
                  },
                );
              }),
            )
          : const Center(
              child: Text(
                'No items were found',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
