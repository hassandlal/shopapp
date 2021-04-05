import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:shop_app/models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
   bool isFavourite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imgUrl,
    this.isFavourite = false,
  });
  void _setFavValue(bool newValue){
    isFavourite = newValue;
    notifyListeners();
  }
  Future<void> toggleFavoouiteStatues(String token,String userId) async{
    final oldStatues = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://shop-app-7211e-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try{
      final res =await http.put(url,body: json.encode(isFavourite));
      if(res.statusCode>= 400){
        _setFavValue(oldStatues);
      }
    }catch(e){
      _setFavValue(oldStatues);
    }
  }
}
