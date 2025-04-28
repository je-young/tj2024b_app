// example2.dart : text 입력 폼

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 1. 시작점
void main(){ runApp( MyApp() ); }

// 2-1. 상태 있는 앱 화면 선언
class MyApp extends StatefulWidget{
  // 상태를 사용할 위젯명 설정
  MyAppState createState() => MyAppState();
}
// 2-2
class MyAppState extends State< MyApp >{
  // 1. 입력 컨트롤러 이용한 입력값들을 제어한다. TextEditingController();
  // 2. 생성한 입력컨트롤러 객체를 대입한다. TextField( controller : 입력컨트롤러객체 )
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  // 3. 입력받은 값 추출 , 입력컨트롤러객체.text
  void onEvent(){
    print( controller1.text);
    print( controller2.text);
    print( controller3.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text(" 입력 화면 헤더 "),),
          body : Center(
            child: Column(
              children: [
                SizedBox( height: 30,), // 빈공간 위젯을 이용하여 높이 설정 ( 여백 역할 )

                Text("아래 내용들을 입력해주세요."), // 텍스트 출력 위젯
                SizedBox( height: 30,), // 빈공간 위젯을 이용하여 높이 설정  ( 여백 역할 )

                TextField( controller: controller1, ), // 텍스트 입력 위젯
                SizedBox( height: 30,),

                TextField( maxLength: 30 , controller: controller2, ), // 텍스트 입력 위젯 , 최대 입력 글자수 제한
                SizedBox( height: 30,),

                TextField(
                  maxLines: 5 ,  // 최대 입력 줄수 제한 , 입력에 따라 자동 확장 된다.
                  controller: controller3,
                  decoration: InputDecoration( labelText: "가이드 텍스트"),
                ),
                SizedBox( height: 30,),

                TextButton( // 텍스트 이벤트버튼
                  onPressed: onEvent,
                  child: Text("클릭시 입력값을 출력합니다."),
                )
              ],
            ),
          )
      ),
    );
  }
} // class end
