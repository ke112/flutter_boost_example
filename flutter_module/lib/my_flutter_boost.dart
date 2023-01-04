import 'dart:convert';

import 'package:flutter_boost/flutter_boost.dart';

class MyFlutterBoostDelegate {
  static pushNativePage({
    required String pageName,
    Map? arguments,
  }) {
    Map<String, dynamic>? params = jsonDecode(jsonEncode(arguments));
    params?['animated'] = true;
    BoostNavigator.instance.push(pageName, arguments: params).then((value) {
      print("flutter端打印,iOStoflutter参数: ${value?.toString()}");
    });
  }
}
