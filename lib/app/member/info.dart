import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_study/app/layout/mainapp.dart';
import 'package:flutter_study/app/member/login.dart';


class Info extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _InfoState();
  }
} // end Info

class _InfoState extends State<Info>{
  // 1. 상태 변수
  int mno = 0; // 30;
  String memail = ""; //"qwe@qwe.com";
  String mname = ""; // "유재석";

  // 2. 해당 페이지(위젯) 열렸을때 실행되는 함수
  @override
  void initState() { loginCheck(); }

  // 3. 로그인 상태를 확인 하는 함수
  bool? isLogin; // Dart문법 중에 타입? 은 null 포함할 수 있다 뜻
  void loginCheck() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if( token != null && token.isNotEmpty ){ // 전역변수에 (로그인)토큰이 존재하면
      setState(() {
        isLogin = true; print("로그인 중");
        onInfo( token ); // 로그인 중일때 로그인 정보 요청 함수 실행
      });
    }else{ // 비로그인 중일때 페이지 전환/이동
      // Navigator.pushReplacement( context , MaterialPageRoute(builder: (context) => 이동할위젯명() ) );
      Navigator.pushReplacement( context , MaterialPageRoute(builder: (context) => Login() ) );
    }
  } // end loginCheck

  // 4. 로그인된 (회원) 정보 요청 , 로그인 중일때 실행
  void onInfo( token ) async {
    try{
      Dio dio = Dio();
      //* Dio 에서 Headers 정보를 보내는 방법 , Options
      // 방법1 : dio.options.headers['속성명'] = 값;
      // 방법2 : dio.get( options : { headers : { '속성명' : 값 } } )
      dio.options.headers['Authorization'] = token;
      final response = await dio.get( "http://192.168.40.107:8080/member/info" );
      final data = response.data; print( data );
      if( data != '' ) { // (로그인) 회원정보가 존재하면
        setState(() {
          memail = data['memail'];
          mname = data['mname'];
          mno = data['mno'];
        });
      }
    }catch(e){ print(e); }
  } // end onInfo

  // 5. 로그아웃 요청
  void logout() async{
    // 1. 전역변수 에서 토큰 꺼낸다.
    final prefs =  await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if( token == null  ) return; // 없으면 함수 종료
    // 2. 서버에게 로그아웃 요청
    Dio dio = Dio();
    dio.options.headers['Authorization'] = token;
    final response = dio.get("http://192.168.40.9:8080/member/logout");
    // 3. 전역변수(클라이언트) 에도 토큰 삭제
    await prefs.remove('token');
    // 4. 페이지 전환/이동
    Navigator.pushReplacement( context , MaterialPageRoute( builder: (context)=> MainApp() ));
  } // end logout

  // 6.
  @override
  Widget build(BuildContext context) {

    // - 만약에 로그인상태가 확인 되기 전 , 대기 화면 표현
    if( isLogin == null ){ // 만약에 비로그인 이면
      return Scaffold( // CircularProgressIndicator() : 로딩 화면 제공 위젯
        body: Center( child: CircularProgressIndicator(),),
      );
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all( 30 ),
        padding: EdgeInsets.all( 30 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("회원번호 : $mno"),
            SizedBox( height: 20,),
            Text("아이디(이메일) : $memail  "),
            SizedBox( height: 20,),
            Text("이름(닉네임) : $mname"),
            SizedBox( height: 20,),
            ElevatedButton(onPressed: logout , child: Text("로그아웃") ),
          ], // end children
        ), // end Column
      ), // end Container
    ); // end Scaffold
  } // end build
} // end _InfoState