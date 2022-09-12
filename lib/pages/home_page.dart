import 'package:crypto_funding_app/models/funding_item.dart';
import 'package:crypto_funding_app/pages/item_details_page.dart';
import 'package:crypto_funding_app/providers/database_provider.dart';
import 'package:crypto_funding_app/widgets/funding_card.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
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
      body: CustomRefreshIndicator(
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
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!controller.isIdle)
                    Positioned(
                      top: 35.0 * controller.value,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          value: !controller.isLoading
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
