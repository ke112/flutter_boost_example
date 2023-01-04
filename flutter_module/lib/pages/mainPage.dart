import 'package:flutter/material.dart';
import 'package:flutter_module/my_flutter_boost.dart';

class MainPage extends StatelessWidget {
  final String userId;
  const MainPage({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'flutter标题',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 44,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          // color: Colors.green,
          height: 120,
          child: Column(
            children: [
              Text('接收原生的参数userId:$userId'),
              const SizedBox(height: 20),
              const Text('这是flutter界面'),
              const SizedBox(height: 20),
              GestureDetector(
                child: const Text(
                  'flutter跳原生按钮',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                onTap: () {
                  print("flutter跳原生界面");

                  MyFlutterBoostDelegate.pushNativePage(pageName: 'native', arguments: {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
