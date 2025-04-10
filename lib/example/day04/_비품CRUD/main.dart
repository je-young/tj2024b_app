// lib/example/day04/_비품CRUD/main.dart
// 앱 실행의 최초 파일

// Flutter Material 디자인 라이브러리 가져오기
import 'package:flutter/material.dart';
// 각 화면(페이지) 파일 가져오기 (같은 디렉토리에 있으므로 파일명만 사용)
import 'home.dart';
import 'write.dart';
import 'detail.dart';
import 'update.dart';

// 1. main 함수: 앱의 시작점
void main() {
  // runApp 함수에 최상위 위젯(MyApp)을 전달하여 앱 실행
  runApp(MyApp());
} // end main

// 2. MyApp 위젯: 앱의 기본 구조 및 라우팅 설정 (StatelessWidget)
class MyApp extends StatelessWidget {
  // build 메소드: 이 위젯의 UI를 정의
  @override
  Widget build(BuildContext context) {
    // MaterialApp: 머티리얼 디자인 앱의 루트 위젯
    return MaterialApp(
      title: '비품 관리 앱', // 앱의 제목 (OS 작업 관리자 등에 표시될 수 있음)
      debugShowCheckedModeBanner: false, // 개발 중 표시되는 디버그 배너 숨기기
      theme: ThemeData( // 앱의 전체적인 테마 설정
        primarySwatch: Colors.teal, // 기본 색상 견본 ( Teal 색상 사용)
        visualDensity: VisualDensity.adaptivePlatformDensity, // 플랫폼별 시각적 밀도 조정
      ),
      initialRoute: "/", // 앱 시작 시 표시할 초기 경로 이름
      // routes: 이름 있는 경로(Named Routes)와 해당 경로에 표시될 위젯을 매핑
      routes: {
        "/" : (context) => HomeScreen(),       // 루트 경로('/')는 HomeScreen 위젯 표시
        "/add" : (context) => AddSupplyScreen(), // '/add' 경로는 AddSupplyScreen 위젯 표시
        "/detail" : (context) => DetailScreen(),    // '/detail' 경로는 DetailScreen 위젯 표시
        "/update" : (context) => UpdateScreen(),    // '/update' 경로는 UpdateScreen 위젯 표시
      }, // end routes
    ); // end MaterialApp
  } // end build
} // end MyApp