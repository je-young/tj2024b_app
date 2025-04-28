// update.dart : 수정 화면 파일
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 상태 있는 위젯 만들기
class Update extends StatefulWidget{
  @override
  _UpdateSate createState() {
    return _UpdateSate();
  }
}
class _UpdateSate extends State<Update> { // 클래스명 앞에 _ 언더바는 dart에서 private 키워드

  // 1.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // (1)  이전 위젯으로 부터 전달받은 인수(arguments)를 가져오기.
    int id = ModalRoute.of( context )!.settings.arguments as int;
    print( id );
    // (2) 전달받은 인수(id)를 자바에게 보내고 응답객체 받기
    todoFindById( id );
  }
  // 2.
  Dio dio = Dio();
  Map< String, dynamic > todo = {}; // JSON 타입은 key은 무조건 문자열 그래서 String , value은 다양한 자료타입 이므로 dynamic(동적타입)
  void todoFindById( int id ) async {
    try{
      final response = await dio.get("https://then-heloise-itdanjalog-5d2c7fb5.koyeb.app/day04/todos/view?id=$id");
      final data = response.data;
      setState(() {
        todo = data;
        // 입력컨트롤러에 초기값 대입하기.
        titleController.text = data['title'];
        contentController.text = data['content'];
        done = data['done'];
      });
      print( todo );
    }catch(e){ print( e ); }
  }

  // 3. 입력컨트롤러 상태 변수
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  // 완료 여부를 저장하는 상태변수 , 컨트롤러 없이 직접 렌더링
  bool done = true;
  // 4. 현재 수정된 값으로 자바에게 수정처리 요청하기.
  void todoUpdate(  ) async{
    try{
      final sendData = {
        "id" : todo['id'], // 기존의 id 가져온다.
        "title" : titleController.text, // 수정할 입력받은 제목 을 가져온다.
        "content" : contentController.text, // 수정할 입력받은 내용 을 가져온다.
        "done" : done , // 수정된 할일 상태
      };// 수정에 필요한 데이터
      //final response =  await dio.put("http://192.168.40.9:8080/day04/todos" , data : sendData );
      final response =  await dio.put("https://then-heloise-itdanjalog-5d2c7fb5.koyeb.app/day04/todos" , data : sendData );
      final data = response.data;
      if( data != null ){  // 만약에 응답결과가 null 아니면 수정 성공
        Navigator.pushNamed(context, "/" ); // home 위젯으로 이동
      }
    }catch(e){ print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("수정 화면 "),),
      body: Center(
        child: Column(
          children: [
            SizedBox( height: 20,) ,
            TextField(
              controller: titleController,
              decoration: InputDecoration( labelText: "제목"),
              maxLength: 30,
            ),

            SizedBox( height: 20,) ,
            TextField(
              controller: contentController,
              decoration: InputDecoration( labelText: "내용"),
              maxLines: 3,
            ),

            SizedBox( height: 20,) ,
            Text("완료 여부"),
            Switch( // 스위치 위젯 , on/off 역할
              value: done, // 현재 스위치 값 , true 또는 false
              onChanged : (value)=>{ setState((){ done = value; }) },  // 스위치 값이 변경 되었을때
              // onChanged : (변경된값){ setState(() { 상태변수 = 변경된값; }); }, // setState(){} 라이브러리 이므로 => 생략된 상태
              // 또는
              // onChanged : (변경된값)=>{ setState(() { 상태변수 = 변경된값; }) }, // => 사용시에는 ; 생략 가능
            ),

            SizedBox( height: 20,) ,
            OutlinedButton( onPressed: todoUpdate, child: Text("수정하기") ),
          ],
        ),
      ),
    ); // scaffold end
  }
}








