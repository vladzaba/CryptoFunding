class FundingItem {
  final String id;
  final String name;
  final String description;
  final String creator;
  final String image;
  final num price;
  final String bscAddress;
  final String ethAddress;
  late DateTime whenAdded;

  FundingItem({
    required this.id,
    required this.name,
    required this.description,
    required this.creator,
    required this.image,
    required this.price,
    required this.bscAddress,
    required this.ethAddress,
    required this.whenAdded,
  });

  factory FundingItem.fromJson(Map<String, dynamic> json) {
    return FundingItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creator: json['creator'],
      image: json['image'],
      price: json['price'],
      bscAddress: json['bsc_address'],
      ethAddress: json['eth_address'],
      whenAdded: json['time'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator': creator,
      'image': image,
      'price': price,
      'bsc_address': bscAddress,
      'eth_address': ethAddress,
      'time': whenAdded,
    };
  }
}
