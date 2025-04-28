// lib/main.dart : 앱 실행 시작점


import 'package:flutter/material.dart';
import 'package:flutter_study/book_app/presentation/screens/home_screen.dart'; // [1] HomeScreen import (동일)

void main() {
  runApp(const MyApp()); // [2] 앱 실행 시작점 (동일)
}

// [3] 앱 루트 위젯 (동일)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [4] MaterialApp 위젯 반환 (동일)
    return MaterialApp(
      title: '익명 도서 추천',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), // [5] 첫 화면 지정 (동일)
      debugShowCheckedModeBanner: false,
    );
  } // end build
} // end MyApp