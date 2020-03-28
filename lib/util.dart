import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conf.dart';

Future<Map> jsonGet(String url, [Map<String, String> queryParameters]) async {
  var client = HttpClient();
  var uri = Uri.parse(url).replace(queryParameters: queryParameters);
  try {
    var request = await client.getUrl(uri).timeout(Duration(seconds: REQ_TIMEOUT));
    var response = await request.close().timeout(Duration(seconds: REQ_TIMEOUT));
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return data;
  } on TimeoutException catch(_) {
    return {'error': '网络超时'};
  } on SocketException catch(_) {
    return {'error': '网络错误'};
  } on HttpException catch(_) {
    return {'error': '网络错误'};
  }  on FormatException catch(_) {
    return {'error': '网络报文格式错误'};
  } on Exception catch(_) {
    return {'error': '未知错误'};
  }
}

Future<Uint8List> getNetworkImageData(imageUrl) async {
  final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
  return imageData.buffer.asUint8List();
}

bool isBlank(String str) => str == null || str.trim().isEmpty;

class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs); 

  static Future<LocalStorage> getInstance() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return LocalStorage(prefs);
  }

  String getString(key, [String defaultValue]) {
    String value = prefs.getString(key);
    return value == null || value.trim().isEmpty ? defaultValue : value;
  }

  bool getBool(key, [bool defaultValue]) {
    bool value = prefs.getBool(key);
    return value ?? defaultValue;
  }

  Future<bool> setString(String key, String value) => prefs.setString(key, value);

  Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);
}

/// 时间字符串
String timeString() {
  DateTime n = new DateTime.now();
  return '${n.year}-${n.month}-${n.day}-${n.hour}-${n.minute}-${n.second}-${n.millisecond}';
}

/// 使用SnackBar提示信息
void tip(BuildContext context, String msg, {int seconds = 1}) {
  final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: seconds));
  Scaffold.of(context).showSnackBar(snackBar);
}