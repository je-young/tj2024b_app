// main.dart : 앱 실행의 최초 파일

import 'package:flutter/material.dart';
import 'home.dart';
import 'write.dart';

// 1. main 함수 이용한 앱 실행
void main() {
  runApp(MyApp()); // 라우터를 갖는 위젯이 최소 화면
} // end main

// 2. 라우터를 갖는 클래스 / 위젯
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/", // 앱이 실행 했을때 초기 경로 설정
      routes: {
        "/" : (context) => Home(), // 만약에 "/" 해당 경로를 호출하면 Home 위젯이 열린다.
        "/write" : (context) => Write(),
        // "/update" : (context) => Update(), // 추후에 위젯 만들고 주석 풀기
      }, // end routes
    ); // end MaterialApp
  } // end build
} // end MyApp