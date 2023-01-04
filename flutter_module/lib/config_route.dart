import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/pages/mainPage.dart';
import 'package:flutter_module/pages/simplePage.dart';

class ConfigRoute {
  static Map<String, FlutterBoostRouteFactory> routerMaps = {
    'default': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const Material(
              child: Center(child: Text('module默认页')),
            );
          });
    },
    'mainPage': (settings, uniqueId) {
      print('flutter 打印: $settings');
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            // argument : {present: false, animated: true, userId: 123456}
            print('1111111111');
            print(settings.arguments.runtimeType);
            String jsonStr = json.encode(settings.arguments);
            Map params = json.decode(jsonStr);
            print('params: $params');
            return MainPage(
              userId: params['userId'] ?? '',
            );
          });
    },
    'simplePage': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, Object>? map = settings.arguments as Map<String, Object>?;
            return SimplePage(
              data: map?['data'] ?? '',
            );
          });
    },
  };
}
