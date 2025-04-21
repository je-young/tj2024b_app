import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  } // end createState
} // end Login

class _LoginState extends State<Login> {
  // 1. 입력상자 컨트롤러
  TextEditingController emailControl = TextEditingController();
  TextEditingController pwdControl = TextEditingController();

  // 2. 자바와 통신
  void onLogin() async {
    try {
      Dio dio = Dio();
      final sendData = {"memail": emailControl.text, "mpwd": pwdControl.text};
      final response = await dio.post("http://localhost:8080/member/login", data: sendData,);
      final data = response.data;
      if (data != '') {
        // 로그인 성공시 토큰 SharedPreferences 저장하기.
        // 1. 전역변수 호출
        final prefs = await SharedPreferences.getInstance();
        // 2. 전역변수 값 추가
        await prefs.setString('token', data);
      } else {
        print("로그인 실패 ");
      }
    } catch (e) {
      print(e);
    }
  } // end onLogin

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 레이아웃 위젯
      body: Container( // 여백 제공하는 박스 위젯
        padding: EdgeInsets.all( 30 ) , // 박스 안쪽 여백
        margin: EdgeInsets.all( 30 ) , // 박스 바깥 여백
        child: Column( // 하위 요소 세로 위젯
          mainAxisAlignment: MainAxisAlignment.center, // 현재 축(Column) 기준으로 정렬
          children: [ // 하위 요소들 위젯
            TextField(  controller: emailControl,
              decoration: InputDecoration( labelText: "이메일" , border: OutlineInputBorder() ),
            ),
            SizedBox( height: 20 , ),
            TextField(  controller: pwdControl, obscureText: true, // 입력값 감추기
              decoration: InputDecoration( labelText: "비밀번호" , border: OutlineInputBorder()),
            ),
            SizedBox( height: 20 , ),
            ElevatedButton( onPressed: onLogin , child: Text("로그인") ),
            SizedBox( height: 20 ,),
            TextButton(onPressed: ()=>{}, child: Text("처음 방문이면 _회원가입") )
          ],
        ),// end Column
      ), // end Container
    ); // end Scaffold
  } // end build
} // end _LoginState
