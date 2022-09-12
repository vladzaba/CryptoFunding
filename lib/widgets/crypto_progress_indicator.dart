import 'package:crypto_funding_app/models/funding_item.dart';
import 'package:crypto_funding_app/providers/crypto_fetch_provider.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:provider/provider.dart';

class CryptoProgressIndicator extends StatelessWidget {
  final FundingItem fundingItem;
  final double width;

  const CryptoProgressIndicator({
    Key? key,
    required this.fundingItem,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CryptoFetchProvider(
            bscAddress: fundingItem.bscAddress,
            ethAddress: fundingItem.ethAddress,
          ),
        )
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        var fetchProvider = context.watch<CryptoFetchProvider>();
        double percent = getPercent(fetchProvider.totalBalance);

        return fetchProvider.isLoading
            ?  SizedBox(
                width: width,
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                barRadius: const Radius.circular(12),
                width: width,
                lineHeight: 20.0,
                percent: fetchProvider.totalBalance < fundingItem.price
                    ? percent / 100
                    : 1,
                backgroundColor: Colors.grey,
                center: fetchProvider.totalBalance < fundingItem.price
                    ? Text('$percent%')
                    : const Text('Finished'),
                progressColor: fetchProvider.totalBalance < fundingItem.price
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
