import '../models/transaction.dart';
import 'glass_container.dart';

import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final double ethPrice;
  final double bnbPrice;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.ethPrice,
    required this.bnbPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double value = double.parse(transaction.value) / 1000000000000000000;

    return ZoomTapAnimation(
      onTap: () {
        launchUrl();
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 14,
                ),
                Text(
                  timeago.format(transaction.time),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            GlassContainer(
              width: 500,
              height: 75,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        transaction.chain == 'eth'
                            ? const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/eth_logo.png'),
                                radius: 16,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/bsc_logo.svg.png'),
                                radius: 16,
                              ),
                        Row(
                          children: [
                            Text(
                              '+${value.toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 57, 225, 62),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '≈ $valueInDollars\$',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'Sender: ${transaction.fromWallet}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get valueInDollars {
    double cryptoPrice;

    if (transaction.chain == 'eth') {
      cryptoPrice = ethPrice;
    } else {
      cryptoPrice = bnbPrice;
    }
    return (double.parse(transaction.value) / 1000000000000000000 * cryptoPrice)
        .toStringAsFixed(2);
  }

  Future<void> launchUrl() async {
    if (transaction.chain == 'bsc') {
      launchUrlString('https://testnet.bscscan.com/tx/${transaction.hash}');
    } else if (transaction.chain == 'eth') {
      launchUrlString('https://rinkeby.etherscan.io/tx/${transaction.hash}');
    } else {
      throw Exception('Something wrong happened');
    }
  }
}
