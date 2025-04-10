// detail.dart : 상세 화면 파일

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


// 상태 있는 위젯
class Detail extends StatefulWidget{
  @override
  _DetailState createState() {
    return _DetailState();
  } // end createState
} // end class

class _DetailState extends State<Detail>{
  // * 1. 이전 화면에서 arguments를 가져오기
  // 전제조건 : Navigator.pushNamed(context , "/경로" , arguments : 인자값 )
  // ModalRoute.of( context )!.settings.arguments as 인자값타입

  // (1). initState() 해당 위젯이 최초로 열렸을때 딱 1번 실행 하는 함수 (생명주기)
  // (2). didChangeDependencies() 부모 위젯이 변경 되었을때 실행 되는 함수 (위젯 생명주기)

  // * 1. 이전 위젯으로 부터 매개변수로 받은 id 를 가져오기
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    int id = ModalRoute.of( context )!.settings.arguments as int; // 이전 위젯으로 부터 매개병수로 받은 id 를 가져오기
    todoFindById( id ); // 가져온 id 를 서버에게 보내서 정보를 요청하기.
  } // end didChangeDependencies

  // * 2. 자바 와 통신 하여 id 에 해당 하는 상세 정보 요청
  Dio dio = Dio();
  Map<String , dynamic> todo = {}; // 응답 결과를 저장하는 하나의 '일정' 객체 선언
  void todoFindById(int id) async {
    try {
      //final response = await dio.get('http://localhost:8080/day04/todos/view?id=$id'); // dio를 이용한 GET 통신
      //final response = await dio.get('http://10.0.2.2:8080/day04/todos/view?id=$id'); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final response = await dio.get('https://accurate-keriann-jey2965-01e9656d.koyeb.app/day04/todos/view?id=$id'); // ✅ 배포후 IP 주소
      final data = response.data;
      setState(() {
        todo = data; // 응답받은 결과를 상태변수에 대입
      }); // end setState
      print(todo);
    } catch (e) {
      print(e);
    } // end catch
  } // end todoFindById

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("상세 화면"),),
      body: Center(
        child: Column(
          children: [
            Text("제목 : ${todo["title"]}" , style: TextStyle(fontSize: 25),),
            SizedBox(height: 8,), // 여백

            Text("내용 : ${todo["content"]}" , style: TextStyle(fontSize: 20),),
            SizedBox(height: 8,), // 여백

            Text("완료 여부 : ${todo["done"] == 'true' ? '완료': '미완료'}" , style: TextStyle(fontSize: 15),),
            SizedBox(height: 8,), // 여백

            Text("할일 등록일 : ${todo["createdAt"]}" , style: TextStyle(fontSize: 15),),
            SizedBox(height: 8,), // 여백
          ], // end children
        )
      ),
    ); // end Scaffold
  } // end build
} // end class