import 'package:crypto_funding_app/models/funding_item.dart';
import 'package:crypto_funding_app/pages/item_details_page.dart';
import 'package:crypto_funding_app/providers/database_provider.dart';
import 'package:crypto_funding_app/widgets/funding_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseProvider>();

    List<FundingItem> fundingList = db.fundingList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff263742),
        title: const Text('Fundings'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/profile');
          },
          icon: const Icon(Icons.account_circle),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add_item');
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xff1e2c37),
      body: RefreshIndicator(
        color: const Color(0xff1e2c37),
        onRefresh: () async {
          db.getItems();
        },
        child: Center(
          child: db.isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : ListView.builder(
                  itemCount: fundingList.length,
                  itemBuilder: ((context, index) {
                    return ZoomTapAnimation(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ItemDetailsPage(
                              fundingItem: fundingList[index],
                            ),
                          ),
                        );
                      },
                      child: FundingCard(
                        fundingItem: fundingList[index],
                      ),
                    );
                  }),
                ),
        ),
      ),
    );
  }
}
