// write.dart : 등록 화면 파일

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 상태 있는 위젯 만들기
class Write extends StatefulWidget {
  @override
  _WriteState createState() {
    return _WriteState();
  } // end createState
} // end Write

class _WriteState extends State<Write> {
  // 1. 텍스트 입력상에 사용되는 컨트롤러 객체 선언, 목적 : 입력받은 값 가져오기 위해서
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 2. 자바에게 통신하여 할일 등록 처리하는 함수
  Dio dio = Dio();
  void todoSave() async {
    try {
      final sendData = {
        "title" : titleController.text, // 입력한 제목
        "content" : contentController.text , // 입력한 내용
        "done" : false // 상태
      }; // end sendData
      final response = await dio.post('http://10.0.2.2:8080/day04/todos', data: sendData); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final data = response.data;
      if(data != null){ // 등록 성공시
        Navigator.pushNamed(context, "/"); // 라우터 이용한 "/" 경로로 이동
      } // end if
    }catch(e){
      print(e);
    } // end catch
  } // end todoSave

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("할일 등록 화면")),
      body: Center(
        child: Column(
          children: [

            Text("할일을 등록 해보세요."), // 텍스트 위젯

            SizedBox(height: 30,),

            TextField(
              controller: titleController ,
              decoration: InputDecoration(labelText: "할일 제목"), // 입력 가이드 제목
              maxLength: 30, // 입력 글자 제한 수
            ), // end TextField

            SizedBox(height: 30,),

            TextField(
              controller: contentController ,
              decoration: InputDecoration(labelText: "할일 내용"), // 입력 가이드 제목
              maxLength: 30, // 입력 글자 제한 수
            ), // end TextField

            SizedBox(height: 30,),

            OutlinedButton(onPressed: todoSave, child: Text("등록하기"))

          ], // end children
        ), // end Column
      ) // end Center
    ); // end Scaffold
  } // end build
} // end _WriteState