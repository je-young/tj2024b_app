// 플러터 :dart 언어(google) 기반의 프레임워크
// dart 언어 클래스 : 첫글자 대문자 시작
// dart 언어 인스턴스생성 : 클래스명()
// 위젯 : 화면을 그려내는 최소의 단위 , 클래스기반(첫글자 대문자)
// 위젯 사용법
  // 1. 위젯명 : 클래스명과 동일하게 첫글자가 대문자이다.
  // 2. ( ) : 클래스명 뒤에 생성자 처럼 초기값 대입하는 매개변수 자리
    // java : new Member("유재석" , 40);
    // Member(name : "유재석" , age : 40);

// 위젯 안에 위젯 == 객체 안에 객체
  // 3. 위젯명(속성명 : 위젯명(속성명 : 위젯명()))
// 속성 : 각 위젯들이 정의한 속성명들이 존재한다.

// 4. 위젯 트리 : 위젯 구조
/*
  MyApp( StatelessWidget ) : 상태 없는 위젯(화면)
    -> build
      -> MaterialApp
        -> home
          -> Scaffold
            -> appBar
              -> AppBar
                -> Text
              -> body
                -> Text
              -> bottomNavigationBar
                -> BottomAppBar
                  -> Text
*/
import 'package:flutter/material.dart';

// 1. 플러터 실행
void main(){
  print('콘솔에 출력하기');
  // 디바이스 선택 후 실행 : web , app
  runApp(MyApp2()); // runApp(클래스명())
} // end main

// 2. 클래스생성 , StatelessWidget : 상태 없는 위젯 제공
class MyApp1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 뼈대
        home: Scaffold( // 레이아웃( 헤더/푸터/본문/하단메뉴/사이드바 등등 )
          // 속헝명 : 위젯명()
          appBar: AppBar(title : Text("여기는 상단메뉴")) , // 상단메뉴
          body: Center(child: Text("여기는 본문")), // 본문
          bottomNavigationBar: BottomAppBar(child: Text("여기는 하단 메뉴")) // 하단메뉴
    ));
  } // end build
} // end MyApp1

// 3. 상태 없는 위젯이란? StatelessWidget : 고정된(불변) UI
class MyApp2 extends StatelessWidget{

  int count = 0; // 값 변수
  void increment(){
    count++;
    print(count);
  } // 증가 함수

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 모든 위젯을 감싼 뼈대 역할 의 위젯
        home: Scaffold( // 레이아웃 구성하는 위젯
          appBar: AppBar(title: Text("여기는 상단메뉴")), // 상단바 위젯
          body: Center( // 가로 가운데 정렬 위젯
            child: Column( // 여러개 위젯을 세로 배치 위젯
              children: [
                Text("여기는 본문"), // 텍스트 위젯
                TextButton( // 텍스트 버튼 위젯
                    onPressed: increment, // onClick , 버튼 클릭했을때
                    child: Text("버튼클릭하세요."))
              ], // end children
            )
          ),
        )
    );
  } // end build
} // end MyApp2
// Column( children : [ Text("여기는 본문") , Text("여기는 본문") ] )









