// 위젯 : 화면을 그려내는 최소 단위
// 위젯명( 속성명 : 위젯명 , 속성명 : 위젯명 );             = 객체
// vs new 클래스명( 매개변수 , 매개변수 , 매개변수 );       = 객체

import 'package:flutter/material.dart';
// 1. 플러터 시작 , 시작점 에서 runApp( ) 에서 최초로 실행할 위젯의 객체 대입
void main(){
  // runApp( 최초실행할위젯 );
  runApp(
      MaterialApp(
        initialRoute : "/" , // 최초로 실행 했을때 열리는 경로 정의 , http://localhost:10767/
        // routes : { "경로정의" : (context)=>위젯명()  , "경로정의" : (context)=>위젯명() }
        routes: {
          "/" : (context) => Home(), // http://localhost:10767/
          "/page1" : (context) => Page1(), // http://localhost:10767/#/page1
        },
      )
  );
} // main end

// 2-1. 앱 화면 만들기. 2가지 선택사항 : 1.상태없는 : StatelessWidget , 2.상태있는 : StatefulWidget
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text( "메인페이지 헤더"), ),
      body : Center(
        child: Column(
          children: [
            Text("메인페이지 본문") ,
            TextButton(
              onPressed : ()=>{ Navigator.pushNamed(context, "/page1") } , //
              child: Text('page1 로 이동 버튼'),
            ),
          ],
        ),
      ),
    );
  }
}

// 2-2 앱 화면 만들기 . 2가지 선택사항 : 1.상태없는 : StatelessWidget , 2.상태있는 : StatefulWidget
class Page1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text( "PAGE1 헤더"),),
      body: Center( child: Text("PAGE1 본문"),),
    );
  }
}
