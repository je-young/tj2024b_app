


import 'package:flutter/material.dart';

void main(){ // 프로그램 진입점
runApp(MyApp2());
} // end main

// (1) 간단한 화면 만들기 , class 클래스명 extends statelessWidget{}
// StatelessWidget : 상태가 없는 인터페이스
//    -> build 추상메소드 : 하나의 추상메소드를 제공한다.
class MyApp1 extends StatelessWidget{
  // 컨트롤 +스페이스바 : build 함수 재정의 (오버라이딩)
  @override
  Widget build(BuildContext context) {
    // 기존 코드 지우고 return 출력할위젯
    return MaterialApp(home: Text("안녕하세요 플러터 , 리로드"));
  }
}

// (2) 간단한 레이아웃 화면 만들기
class MyApp2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //return MaterialApp(home: Scaffold());
   return MaterialApp(
       home: Scaffold(
         appBar: AppBar(title : Text("여기는 상단메뉴")) , // 상단메뉴
         body: Center(child: Text("여기는 본문")), // 본문
         bottomNavigationBar: BottomAppBar(child: Text("여기는 하단 메뉴")) // 하단메뉴
       ));
  }
}