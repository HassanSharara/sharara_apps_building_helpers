import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sharara_apps_building_helpers/src/Cache/BoxCache/cache_settings.dart';

abstract class BasicCache {
  final CacheSettings settings;
  final String boxName;
  final String boxKey;
  BasicCache({required this.boxName,final String? boxKey,final CacheSettings? settings}):
        settings = settings??CacheSettings.basic(),
        boxKey = boxKey ?? boxName;

  String get _randomEndValue {
    String x = "RandomBDataEnder%\$@#!_**&(&(*()==)(&)**^(#@(%ShararaUseHisPower";
    final List<String> chars = x.characters.toList();
    chars.shuffle();
    return chars.join();
  }

  dynamic exportData(final dynamic data){
    if(data == null || data is! String) return null;
    final List<String> splitter = data.split(settings.secret);
    if(splitter.length<2)return null;
    final List<int> bytes =  base64.decode(splitter.first);
    return utf8.decode(bytes);
  }

  String hashData(final dynamic data){
    if(settings.secret.isEmpty)return data;
    final String baseHashedData = "${base64.encode(
      utf8.encode(data.toString())
    )}${settings.secret}$_randomEndValue";
    return baseHashedData;
  }
}
