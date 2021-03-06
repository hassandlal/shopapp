import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=AIzaSyB-9xNOMkzm8se7mNKeYVegdjoifQYtK9Q';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
       throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toString()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
  Future<bool> tryAutologin() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;
    final extractedData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now()))return false;
    _token = extractedData['token'];
    _userId=extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs =await SharedPreferences.getInstance();
    prefs.clear();
  }
  Future<void> _autoLogout() async{
    if(_authTimer!=null){
      _authTimer.cancel();

    }
    final timeToExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds:timeToExpiry ), logout);
  }
}
