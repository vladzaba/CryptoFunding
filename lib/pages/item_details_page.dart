import 'package:crypto_funding_app/themes/text_styles.dart';

import '../models/funding_item.dart';
import '../models/transaction.dart';
import '../providers/crypto_fetch_provider.dart';
import '../widgets/crypto_progress_indicator.dart';
import '../widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../widgets/full_screen_image.dart';

class ItemDetailsPage extends StatefulWidget {
  final FundingItem fundingItem;

  const ItemDetailsPage({
    Key? key,
    required this.fundingItem,
  }) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late double deviceHeight;
  late double deviceWidth;

  List<Transaction> transactions = [];

  bool isLoading = false;

  @override
  void initState() {
    getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CryptoFetchProvider(
            bscAddress: widget.fundingItem.bscAddress,
            ethAddress: widget.fundingItem.ethAddress,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(builder: (context) {
      var fetchProvider = context.watch<CryptoFetchProvider>();

      return Scaffold(
        backgroundColor: const Color(0xff1e2c37),
        body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: const Color(0xff1e2c37),
                title: const Text('Details'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 0.0,
              ),
            ];
          }),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ZoomTapAnimation(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return FullScreenImage(
                                        image: widget.fundingItem.image,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(widget.fundingItem.image),
                                radius: 64,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.fundingItem.name,
                                  style: TextStyles.titleMedium,
                                ),
                                Text(
                                  '${widget.fundingItem.price}\$',
                                  style: TextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        widget.fundingItem.description.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    widget.fundingItem.description,
                                    style: TextStyles.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'ETH Address',
                          style: TextStyles.titleMedium,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SelectableText(
                          widget.fundingItem.ethAddress,
                          style: TextStyles.bodyMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'BSC Address',
                          style: TextStyles.titleMedium,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SelectableText(
                          widget.fundingItem.bscAddress,
                          style: TextStyles.bodyMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Progress',
                          style: TextStyles.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CryptoProgressIndicator(
                          fundingItem: widget.fundingItem,
                          width: deviceWidth * 0.96,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Collected in BNB: ${fetchProvider.bnbBal.toStringAsFixed(2)} ≈ ${(fetchProvider.bnbBal * fetchProvider.bnbPrice).toStringAsFixed(2)}\$',
                          style: TextStyles.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Collected in ETH: ${fetchProvider.ethBal.toStringAsFixed(2)} ≈ ${(fetchProvider.ethBal * fetchProvider.ethPrice).toStringAsFixed(2)}\$',
                          style: TextStyles.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Total Collected: ${fetchProvider.totalBalance.toStringAsFixed(2)}\$',
                          style: TextStyles.bodyMedium,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Transactions',
                          style: TextStyles.titleMedium,
                        ),
                        ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              transaction: transactions[index],
                              ethPrice: fetchProvider.ethPrice,
                              bnbPrice: fetchProvider.bnbPrice,
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }

  Future<void> getTransactions() async {
    setState(() {
      isLoading = true;
    });

    final String ethUrl =
        'https://api-rinkeby.etherscan.io/api?module=account&action=txlist&address=${widget.fundingItem.ethAddress}&startblock=0&endblock=99999999&sort=asc&apikey=NWK7JXSYT1P6DTCV75JV5GXYBN8TK8MF5B';
    final String bscUrl =
        'https://api-testnet.bscscan.com/api?module=account&action=txlist&address=${widget.fundingItem.bscAddress}&startblock=1&endblock=99999999&page=1&offset=10&sort=asc&apikey=S73BCVF6SCKIWDXMWAMAIUYJH1R2DXBH83';

    // Get ETH transactions
    var ethResponce = await http.get(Uri.parse(ethUrl));
    var ethData = json.decode(ethResponce.body);

    for (var transaction in ethData['result']) {
      if (transaction['to'] == widget.fundingItem.ethAddress.toLowerCase()) {
        transactions.add(
          Transaction.fromJson('eth', transaction),
        );
      }
    }

    // Get BSC transactions
    var bscResponce = await http.get(Uri.parse(bscUrl));
    var bscData = json.decode(bscResponce.body);

    for (var transaction in bscData['result']) {
      if (transaction['to'] == widget.fundingItem.bscAddress.toLowerCase()) {
        transactions.add(
          Transaction.fromJson('bsc', transaction),
        );
      }
    }

    // Sort transactions by time
    transactions.sort((a, b) => a.time.compareTo(b.time));
    transactions = transactions.reversed.toList();

    setState(() {
      isLoading = false;
    });
  }
}
