import '../widgets/fundings_list_buider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/funding_item.dart';
import '../providers/database_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseProvider>();

    List<FundingItem> activeList = db.activeItems;
    List<FundingItem> finishedList = db.finishedItems;

    return Scaffold(
      backgroundColor: const Color(0xff263742),
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text(
                'Active',
                style: TextStyle(color: Colors.white),
              ),
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
            ),
          ];
        }),
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: RefreshIndicator(
            backgroundColor: const Color(0xff263742),
            color: Colors.white,
            onRefresh: () async {
              db.getItems();
            },
            child: Center(
              child: db.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : ListView(
                      children: [
                        FundingsListBuilder(
                          fundingsList: activeList,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        finishedList.isNotEmpty
                            ? FundingsListBuilder(
                                fundingsList: finishedList,
                                title: 'Finished',
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
