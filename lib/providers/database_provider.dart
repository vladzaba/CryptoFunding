import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/funding_item.dart';

class DatabaseProvider extends ChangeNotifier {
  late final FirebaseFirestore db;
  final List<FundingItem> _items = [];

  bool _isLoading = false;

  DatabaseProvider() {
    db = FirebaseFirestore.instance;
    getItems();
  }

  bool get isLoading {
    return _isLoading;
  }

  List<FundingItem> get items {
    return _items.reversed.toList();
  }

  void addItem(Map<String, dynamic> json) async {
    _isLoading = true;
    notifyListeners();

    startTimer();
    await db.collection('items').add(json);

    _isLoading = false;
    notifyListeners();
  }

  void deleteItem(FundingItem item) async {
    _isLoading = true;
    notifyListeners();

    late String dId;
    await db
        .collection('items')
        .where('id', isEqualTo: item.id)
        .get()
        .then((value) {
      dId = value.docs.first.id;
    });

    await db.collection('items').doc(dId).delete();

    _items.removeWhere((value) {
      return value.id == item.id;
    });

    startTimer();

    _isLoading = false;
    notifyListeners();
  }

  void getItems() async {
    _isLoading = true;
    notifyListeners();

    _items.clear();
    await db.collection('items').get().then((item) {
      for (var doc in item.docs) {
        _items.add(
          FundingItem.fromJson(
            doc.data(),
          ),
        );
      }
    });

    _items.sort((a, b) => a.whenAdded.compareTo(b.whenAdded));

    startTimer();

    _isLoading = false;
    notifyListeners();
  }

  void updateStatus(FundingItem item) async {
    late String dId;

    await db
        .collection('items')
        .where('id', isEqualTo: item.id)
        .get()
        .then((value) {
      dId = value.docs.first.id;
    });

    await db.collection('items').doc(dId).update({'is_active': false});
  }

  List<FundingItem> get activeItems {
    return _fundingList.where((element) => element.isActive == true).toList();
  }

  List<FundingItem> get finishedItems {
    return _fundingList.where((element) => element.isActive == false).toList();
  }

  // API can handle only 5 requests per second
  int _index = 0;

  final List<FundingItem> _fundingList = [];

  List<FundingItem> get fundingList {
    return _fundingList;
  }

  startTimer() {
    if (fundingList.length >= items.length) {
      _fundingList.clear();
      _index = 0;
    }
    Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (_fundingList.length >= items.length) {
          timer.cancel();
        } else {
          _fundingList.add(items[_index]);

          notifyListeners();
          _index++;
        }
      },
    );
  }
}
