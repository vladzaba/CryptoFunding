import '../providers/database_provider.dart';

import 'shimmer_details.dart';

import '../models/funding_item.dart';
import '../providers/crypto_fetch_provider.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:provider/provider.dart';

class CryptoProgressIndicator extends StatelessWidget {
  final FundingItem fundingItem;
  final double width;

  final Color baseColor;
  final Color highlightColor;

  const CryptoProgressIndicator({
    Key? key,
    required this.fundingItem,
    required this.width,
    required this.baseColor,
    required this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CryptoFetchProvider(
        bscAddress: fundingItem.bscAddress,
        ethAddress: fundingItem.ethAddress,
      ),
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        var fetchProvider = context.watch<CryptoFetchProvider>();
        var db = context.watch<DatabaseProvider>();

        double percent = getPercent(fetchProvider.totalBalance);

        if (percent >= 100) {
          db.updateStatus(fundingItem);
        }

        return fetchProvider.isLoading
            ? ShimmerCryptoProgressIndicator(
                width: width,
                baseColor: baseColor,
                highlightColor: highlightColor,
              )
            : LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                barRadius: const Radius.circular(12),
                width: width,
                lineHeight: 20.0,
                percent: (percent / 100) < 1 ? percent / 100 : 1,
                backgroundColor: Colors.grey,
                center: fundingItem.isActive
                    ? Text('$percent%')
                    : const Text('Finished'),
                progressColor: fundingItem.isActive
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
              );
      },
    );
  }

  double getPercent(double totalBalance) {
    String p = ((100 * totalBalance) / fundingItem.price).toStringAsFixed(2);

    return double.parse(p);
  }
}
