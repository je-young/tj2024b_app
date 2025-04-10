// update.dart : 수정 화면 파일

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


// 상태 있는 위젯 만들기
class Update extends StatefulWidget {
  @override
  _UpdateState createState() {
    return _UpdateState();
  } // end createState
} // end Update

class _UpdateState extends State<Update> { // 클래스명 앞에 _언더바는 dart 에서 private 키워드이다.
  // 1.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // (1) 이전 위젯으로 부터 전달받은 인수(argument) 를 가져오기
    int id = ModalRoute.of(context)!.settings.arguments as int;
    print(id);
    // (2) 전달받은 인수(id)를 서버에게 보내서 정보를 요청하기.
    todoFindById(id);
  } // end didChangeDependencies

  // 2.
  Dio dio = Dio();
  Map<String, dynamic> todo = {}; // JSON 타입은 key은 무조건 문자열 그래서 String , value은 다양한 자료타입 이므로 dynamic(동적타입)
  void todoFindById(int id) async {
    try {
      //final response = await dio.get('http://localhost:8080/day04/todos/view?id=$id'); // dio를 이용한 GET 통신
      //final response = await dio.get('http://10.0.2.2:8080/day04/todos/view?id=$id'); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final response = await dio.get('https://accurate-keriann-jey2965-01e9656d.koyeb.app/day04/todos/view?id=$id',); // ✅ 배포후 IP 주소
      final data = response.data;
      setState(() {
        todo = data; // 응답받은 결과를 상태변수에 대입
        // 입력컨트롤러에 초기값 대입하기.
        titleController.text = data["title"];
        contentController.text = data["content"];
        done = todo["done"];
      }); // end setState
    }catch(e){
      print(e);
    } // end catch
  } // end todoFindById

  // 3. 입력컨트롤러
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  // 완료 여부를 저장하는 상태변수
  bool done = true;

  // 4. 현재 수정된 값으로 자바에게 수정처리 요청하기.
  void todoUpdate() async {
    try {
      final sendData = {
        "id" : todo["id"], // 기존의 id 가져온다.
        "title" : titleController.text, // 수정할 입력받은 제목을 가져온다.
        "content" : contentController.text , // 수정할 입력받은 내용을 가져온다.
        "done" : done // 수정할 할일 상태
      }; // end sendData
      //final response = await dio.put('http://localhost:8080/day04/todos', data: sendData); // dio를 이용한 PUT 통신
      //final response = await dio.put('http://10.0.2.2:8080/day04/todos', data: sendData); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final response = await dio.put('https://accurate-keriann-jey2965-01e9656d.koyeb.app/day04/todos', data: sendData); // ✅ 배포후 IP 주소
      final data = response.data;
      if(data != null){ // 만약에 응답결과가 null 아니면 수정 성공
        Navigator.pushNamed(context, "/"); // 라우터 이용한 "/" home 경로로 이동
      } // end if
    }catch(e){
      print(e);
    } // end catch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("수정 화면")),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "제목"),
            ), // end TextField

            SizedBox(height: 20,),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: "내용"),
            ), // end TextField

            SizedBox(height: 20,),
            Text("완료 여부"),
            Switch(
                value: done, // 현재 스위치 값 , true , false
                onChanged: (value){ setState(() {
                  done = value;
                });} // 스위치 값 변경 되었을 때
            ), // end Switch

            SizedBox(height: 20,),
            OutlinedButton(onPressed: todoUpdate, child: Text("수정하기"))
          ], // end children
        ) // end Column
      ), // end children
    ); // end Scaffold
  } // end build
} // end _UpdateState