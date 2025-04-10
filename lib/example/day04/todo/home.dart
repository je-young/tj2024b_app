// home.dart : 메인 화면 갖는 앱의 파일

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 1. 상태 있는 위젯
class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  } // end createState
} // end Home

// dart 에서는 클래스/변수 명 앞에 _(언더바) private 뜻한다.
class _HomeState extends State<Home> {
  Dio dio = Dio(); // 1. Dio 객체 생성
  List<dynamic> todolist = []; // 2. 할일 목록을 저장하는 리스트 선언
  // 3. 자바와 통신 하여 할일 목록을 조회하는 함수 선언
  void todoFindAll() async {
    try {
      //final response = await dio.get('http://localhost:8080/day04/todos'); // dio를 이용한 GET 통신
      //final response = await dio.get('http://10.0.2.2:8080/day04/todos'); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final response = await dio.get('https://accurate-keriann-jey2965-01e9656d.koyeb.app/day04/todos'); // ✅ 배포후 IP 주소
      final data = response.data;
      // 조회 결과 없으면 [] , 조회 결과가 있으면 [ {} , {} , {} ]
      // setState 이용하여 재 렌더링한다.
      setState(() {
        todolist = data; // 자바로 부터 응답받은 결과를 상태변수에 저장한다.
      }); // end setState
      print(todolist); // 콘솔에 확인
    } catch (e) {
      print(e);
    } // end catch
  } // end todoFindAll

  // 4. 화면이 최초로 열렸을때 딱 1변 실행 .initState(){ 함수명(); }
  @override
  void initState() {
    super.initState();
    todoFindAll(); // 해당 위젯이 최초로 열렸을때 자바에게 할일 목록 조회 함수 호출
  } // end initState

  // 5. 삭제 이벤트 함수
  void todoDelete(int id) async {
    try {
      //final response = await dio.delete('http://localhost:8080/day04/todos?id=$id'); // dio를 이용한 DELETE 통신
      //final response = await dio.delete('http://10.0.2.2:8080/day04/todos?id=$id',); // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
      final response = await dio.delete('https://accurate-keriann-jey2965-01e9656d.koyeb.app/day04/todos?id=$id',); // ✅ 배포후 IP 주소
      final data = response.data;
      if (data == true) {
        todoFindAll(); // 삭제 성공시 할일 목록 다시 호출 하기.
      } // end if
    } catch (e) {
      print(e);
    } // end catch
  } // end todoDelete

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메인페이지 : TODO")),
      body: Center(
        child: Column(
          children: [
            // (1) 등록 화면으로 이동하는 버튼
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/write"),
              child: Text("할일 추가"),
            ),

            // (2) 간격
            SizedBox(height: 30),

            // (3) ListView 이용한 할일 목록 출력
            // 자바로 부터 가져온 할일 목록을 map 함수를 이용하여 반복해서 Card 형식의 위젯 만들기
            Expanded(
              // Column 위젯 안에서 ListView 사용시 Expanded 위젯 안에서 사용한다.
              child: ListView(
                // ( <ol> )ListView 위젯은 높이 100%의 자동 세로 스크롤 지원한다.
                // children: [] // [] 대신에 map 반복문
                children:
                    todolist.map((todo) {
                      // todolist <==> [{key : value , key : value} , {key : value , key : value}]
                      // todo <==> {key : value , key : value}
                      // todo["key"] <==> value
                      return Card(
                        child: ListTile(
                          title: Text(todo["title"]), // 제목
                          subtitle: Column(
                            children: [
                              // dart 언어 에서 문자와 변수를 같이 출력 하는 방법
                              // 방법1 : 변수값만 출력할 경우에는 , "문자열 $변수명"
                              // 방법2 : 변수안에 key의 값을 출력할 경우에는 , "문자열 ${변수명["key"]}"
                              // { key : value , key : value }
                              Text("할일내용 : ${todo["content"]}"),
                              Text("할일상태 : ${todo["done"]}"),
                              Text("등록일 : ${todo["createdAt"]}"),
                            ], // end children
                          ), // end Column
                          // trailing : ListTile 오른쪽 끝에 표시되는 위젯
                          trailing: Row ( // 하위 위젯들을 가로 배치 vs Coliumn
                            mainAxisSize: MainAxisSize.min, // 배치방법 , 오른쪽 위젯들의 넓이를 자동으로 최소 할당.
                            children: [ // Row 위젯의 자식들
                              IconButton(onPressed: ()=>{ Navigator.pushNamed(context, "/update", arguments: todo["id"]) }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: ()=>{ Navigator.pushNamed(context, "/detail", arguments: todo["id"]) }, icon: Icon(Icons.info)),
                              IconButton(onPressed: () => { todoDelete(todo["id"]) }, icon: Icon(Icons.delete)),
                            ], // end children
                          ) // end Row
                        ), // end ListTile
                      ); // ;(세미콜론) return 마다
                    }).toList(), // map 결과를 toList() 함수를 이용하여 List 타입으로 변환
              ), // end ListView
            ), // end Expanded
          ], // end children
        ), // end Column
      ), // end Center
    ); // end Scaffold
  } // end build
} // end HomeState

/*
Expanded(
  child: ListView( // ListView 위젯은 높이 100%의 자동 세로 스크롤 지원한다.
    children: [
      ListTile(title: Text("항목1"),), // ( <li> )
      ListTile(title: Text("항목2"),), // ( <li> )
    ], // end children
  )
)
*/
