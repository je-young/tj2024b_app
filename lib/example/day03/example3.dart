// 상태위젯 + Rest통신
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 1. main 함수
void main() {
  runApp(MyApp());
}

// 2. 상태 관리 클래스 선언 , StatefulWidget 상속 받으면 꼭 createState() 재정의한다.
class MyApp extends StatefulWidget {
  // - 상태위젯과 연결
  // 방법1 // MyAppState createState(){  return MyAppState(); }
  // 방법2 // MyAppState createState()=>MyAppState();
  MyAppState createState() => MyAppState();
}

// 3. 상태 위젯 클래스 선언 , 상태를 만들고 상태를 관리 할수 있는 상태위젯 만들기.
class MyAppState extends State<MyApp> {
  Dio dio = Dio(); // Dio 라는 객체 생성  , fetch/axios
  // * 상태 변수
  String responseText = "서버응답 결과가 표시되는 곳 ";

  // * dio 라이브러리 이용하여 REST 통신 하는 함수
  void todoSend() async {
    try {
      final sendData = {
        "title": "운동하기",
        "content": "매일10분달리기",
        "done": "false",
      }; // 샘플 데이터

      final response = await dio.post(
        "http://localhost:8080/day04/todos",
        data: sendData,
      ); // dio를 이용하여 POST 통신한다.

      final data = response.data; // 응답 에서 body(본문) 결과만 추출
      // 응답 결과를 상태에 저장 , satSate() 함수를 이용한 상태 랜더링
      setState(() {
        responseText = "응답결과 : $data "; // 상태변수에 새로운 값 대입한다.
      });
    } catch (e) {
      setState(() {
        responseText = "에러발생 : $e";
      });
    }
  } // f end

  // *  dio 라이브러리 이용하여 REST 통신 하는 함수
  // dynamic todoList = []; // 빈 리스트 선언   // dynamic , List<dynamic> , * List<Map<String,dynamic> *
  List< dynamic > todoList = [];
  void todoGet() async {
    try {
      final response = await dio.get("http://localhost:8080/day04/todos");
      final data = response.data;
      print(data);
      // 응답 결과를 상태변수에 대입한다. .setState()
      setState(() {
        todoList = data; // 빈 리스트에 응답 결과를 대입한다.
      });
    } catch (e) {
      print(e);
    }
  } // f end

  // * 위젯이 실행 했을때 최초로 1번 실행하는 함수
  @override
  void initState() {
    super.initState();
    todoGet(); // 모든 할일 목록 가져오기 함수 실행
  }

  @override // setState 실행 될때 마다 다시 실행 된다.
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(

            children: [ // column 하위 위젯 시작

              Text(responseText), // (1) 텍스트 위젯

              TextButton(         // (2) 버튼 위젯
                onPressed: todoSend, // 클릭했을때 이벤트
                child: Text("자바통신"), // 버튼표시할 텍스트
              ),

              OutlinedButton(     // (3) 버튼 위젯
                  onPressed: todoGet,
                  child: Text("자바통신2")
              ),

              Expanded(           // (4) 확장 위젯 : Expanded : column에서 남은 공간을 모두 채워주는 위젯
                  child: ListView(  // ListView 위젯 : 스크롤 이 가능한 목록(리스트) 위젯 , 주의할점 : 부모 요소의 100% 높이 사용한다.
                    // 1. 샘플 예시1
                    // children: [ // ListTile : 목록에 대입할 항목 위젯
                    //   ListTile( title: Text("플러터") ) ,
                    //   ListTile( title: Text("다트") ) ,
                    //   ListTile( title: Text("파이썬")  )
                    // ],

                    // 2. 샘플 예시2
                    // 방법1 * 상태변수에 있는 모든 값들을 반복문 이용하여 출력 하기
                    // children: [
                    //   for( int index = 0 ; index < todoList.length ; index++ ) // 상태변수에 저장된 할일 목록을  순회한다.
                    //     ListTile( title: Text(todoList[index]['title']) ) // index 번째의 할일 제목 을 ListTile 위젯에 Text 대입
                    // ]

                    // 3. 샘플 예시3
                    // 방법2 * map 이란 : 각 리스트/배열의 요소들을 하나씩 순회하여 새로운 리스트/배열 반환 *
                      children : todoList.map( (todo) {
                        return ListTile( title: Text( todo['title'] ) , subtitle: Text( todo['content'] ) );
                      }).toList() // 리스트.map( (반복변수명){ return 위젯명(); } ).toList()
                    // dynamic todoList = [] , map 에서는 오류가 발생한다. List 타입이 아니라서 map 작동 불가능하다.
                    // List<dynamic> todoList = [] , map 에서 정상 작동 한다.

                  )
              ) ,
            ], // column 하위 위젯 end
          ),
        ),
      ),
    );
  } // f end
} // c end
// ctrl+alt+L