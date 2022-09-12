class Transaction {
  final String hash;
  final String fromWallet;
  final String toWallet;
  final String value;
  final DateTime time;

  final String chain;

  Transaction({
    required this.hash,
    required this.fromWallet,
    required this.toWallet,
    required this.value,
    required this.time,
    required this.chain,
  });

  factory Transaction.fromJson(String chain, Map<String, dynamic> json) {
    return Transaction(
      hash: json['hash'],
      fromWallet: json['from'],
      toWallet: json['to'],
      value: json['value'],
      time: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['timeStamp']) * 1000,
      ),
      chain: chain,
    );
  }
}
