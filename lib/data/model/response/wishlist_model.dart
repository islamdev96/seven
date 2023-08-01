// ignore_for_file: unnecessary_getters_setters

import 'package:seven/data/model/response/product_model.dart';

class WishListModel {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<Product>? _products;

  WishListModel({
    int? totalSize,
    String? limit,
    String? offset,
    List<Product>? products,
  }) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _products = products;
  }

  int? get totalSize => _totalSize;
  set totalSize(int? totalSize) => _totalSize = totalSize;
  String? get limit => _limit;
  set limit(String? limit) => _limit = limit;
  String? get offset => _offset;
  set offset(String? offset) => _offset = offset;
  List<Product>? get products => _products;
  set products(List<Product>? products) => _products = products;

  WishListModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <Product>[];
      json['products'].forEach((v) {
        _products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_products != null) {
      data['products'] = _products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
