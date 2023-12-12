import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoFetchProvider extends ChangeNotifier {
  final String bscApiKey = 'S73BCVF6SCKIWDXMWAMAIUYJH1R2DXBH83';
  final String ethApiKey = 'NWK7JXSYT1P6DTCV75JV5GXYBN8TK8MF5B';

  late double _bnbBal = 0;
  late double _ethBal = 0;

  late double _bnbPrice = 0;
  late double _ethPrice = 0;

  late double _totalBalance = 0;

  bool _isLoading = false;

  double get bnbBal {
    return _bnbBal;
  }

  double get ethBal {
    return _ethBal;
  }

  double get bnbPrice {
    return _bnbPrice;
  }

  double get ethPrice {
    return _ethPrice;
  }

  double get totalBalance {
    return _totalBalance;
  }

  bool get isLoading {
    return _isLoading;
  }

  CryptoFetchProvider({
    required String bscAddress,
    required String ethAddress,
  }) {
    getData(bscAddress, ethAddress);
  }

  void getData(String bscAddress, String ethAddress) async {
    _isLoading = true;
    notifyListeners();

    // Getting BSC wallet BNB balance
    String urlBNBBal =
        'https://api-testnet.bscscan.com/api?module=account&action=balance&address=$bscAddress&tag=latest&apikey=$bscApiKey';

    var responceBNBBal = await http.get(Uri.parse(urlBNBBal));
    var dataBNBBal = json.decode(responceBNBBal.body);

    String dataStrBNBBal = dataBNBBal['result'];

    _bnbBal = double.parse(dataStrBNBBal) / 1000000000000000000;

    // Getting ETH wallet ETH balance
    String urlETHBal =
        'https://api-goerli.etherscan.io/api?module=account&action=balance&address=$ethAddress&tag=latest&apikey=$ethApiKey';

    var responceETHBal = await http.get(Uri.parse(urlETHBal));
    var dataETHBal = json.decode(responceETHBal.body);

    String dataStrETHBal = dataETHBal['result'];

    _ethBal = double.parse(dataStrETHBal) / 1000000000000000000;

    // Getting BNB price
    String urlBNBPrice =
        'https://api.coinbase.com/v2/exchange-rates?currency=bnb';

    var responceBNBPrice = await http.get(Uri.parse(urlBNBPrice));
    var dataBNBPrice = json.decode(responceBNBPrice.body);

    String dataStrBNBPrice = dataBNBPrice['data']['rates']['USD'].toString();

    _bnbPrice = double.parse(dataStrBNBPrice);

    // Getting ETH price
    String urlETHPrice =
        'https://api.coinbase.com/v2/exchange-rates?currency=eth';

    var responceETHPrice = await http.get(Uri.parse(urlETHPrice));
    var dataETHPrice = json.decode(responceETHPrice.body);

    String dataStrETHPrice = dataETHPrice['data']['rates']['USD'].toString();

    _ethPrice = double.parse(dataStrETHPrice);

    // Getting total balance in USD
    double bnbBalance = _bnbBal * _bnbPrice;
    double ethBalance = _ethBal * _ethPrice;

    _totalBalance = bnbBalance + ethBalance;

    _isLoading = false;
    notifyListeners();
  }
}
