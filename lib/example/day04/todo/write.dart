// write.dart : 등록 화면 파일
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 1. 상태 있는 위젯 만들기
class Write extends StatefulWidget{
  @override
  _WriteState  createState() {  return _WriteState();  }
}
class _WriteState extends State< Write >{
  // 1. 텍스트 입력상에 사용되는 컨트롤러 객체 선언 , 목적 : 입력받은 값 가져오기 위해서
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  // 2. 자바에게 통신하여 할일 등록 처리하는 함수
  Dio dio = Dio();
  void todoSave() async{
    try{
      final sendData = { // 전송할 내용들
        "title" : titleController.text , // 제목 ,     입력컨트롤러객체.text : 입력받은 값 반환
        "content" : contentController.text , // 내용
        "done" : "false" // 상태 , 초기값
      };
      //final response = await dio.post( "http://192.168.40.9:8080/day04/todos" , data : sendData );
      final response = await dio.post( "https://then-heloise-itdanjalog-5d2c7fb5.koyeb.app/day04/todos" , data : sendData );
      final data = response.data;
      if( data != null ){ // 등록 성공 했으면
        Navigator.pushNamed(context, "/" ); // 라우터 이용한 "/" 메인페이지 이동
      }
    }catch(e){ print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("할일 등록 화면 "),),
      body: Center(
        child: Column(
          children: [
            Text("할일을 등록 해보세요.") , // 텍스트 위젯
            SizedBox( height: 30,) ,
            TextField(  // title 입력받은 텍스트 입력 위젯
              controller: titleController ,
              decoration: InputDecoration( labelText: "할일 제목"), // 입력 가이드 제목
              maxLength: 30, // 입력 글자 제한 수
            ) ,
            SizedBox( height: 30 , ),
            TextField( //  content 입력받은 텍스트 입력 위젯
              controller: contentController ,
              decoration: InputDecoration( labelText: "할일 내용"),
              maxLines: 3, // 기본 줄수 제한 수
            ),
            SizedBox( height:  30 ,) ,
            OutlinedButton( onPressed: todoSave , child: Text("등록하기") )
          ], // 위젯들 end
        ), // column end
      ), // center end
    ); // scaffold end
  } // build end
} // class end