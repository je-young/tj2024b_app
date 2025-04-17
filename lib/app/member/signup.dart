// signup.dart : 회원가입 페이지
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class Signup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SignupState();
  }
}
class _SignupState extends State<Signup>{
  // * 입력 컨트롤러 , 각 입력창에서 입력받은 값을 제어( 반환,호출 등등 )
  TextEditingController emailControl = TextEditingController();
  TextEditingController pwdControl = TextEditingController();
  TextEditingController nameControl = TextEditingController();

  // * 등록 버튼 클릭시
  void onSignup() async{
    // 1.자바에게 보낼 데이터 준비.
    final sendData = {
      'memail' : emailControl.text, // 입력 컨트롤러에 입력된 값 가져오기
      'mpwd' : pwdControl.text,
      'mname' : nameControl.text,
    }; print( sendData ); // 확인
    // 2.
    try {
      Dio dio = Dio();
      final response = await dio.post( "http://localhost:8080/member/signup", data: sendData);
      final data = response.data;
      if (data) { print("회원가입 성공"); }
      else {   print("회원가입 실패");  }
    }catch(e){print(e);}
  } // f end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container( // Container( padding :  , margin : ); 안쪽/바깥 여백 위젯
          padding : EdgeInsets.all( 30 ), // EdgeInsets.all() : 상하좌우 모두 적용되는 안쪽 여백
          margin : EdgeInsets.all( 30 ) , // EdgeInsets.all() : 상하좌우 모두 적용되는 바깥 여백
          child: Column( // 세로배치 위젯
            mainAxisAlignment: MainAxisAlignment.center, // 주 축으로 가운데 정렬( Column 이면 세로 , Row이면 가로 )
            children: [ // 하위 위젯
              TextField(
                controller: emailControl,
                decoration: InputDecoration( labelText: "이메일", border: OutlineInputBorder() ),
              ), // 입력 위젯 , 이메일(id)
              SizedBox( height: 20, ),
              TextField(
                controller: pwdControl,
                obscureText: true, // 입력한 텍스트 가리기
                decoration: InputDecoration( labelText: "비밀번호" , border: OutlineInputBorder() ),
              ), // 입력 위젯 , 패드워드
              SizedBox( height: 20, ),
              TextField(
                controller: nameControl,
                decoration: InputDecoration( labelText: "닉네임" , border: OutlineInputBorder() ),
              ), // 입력 위젯 , 닉네임
              SizedBox( height: 20, ),
              ElevatedButton( onPressed: onSignup , child: Text("회원가입") ),
              TextButton( onPressed: ()=>{}, child: Text("이미 가입된 사용자 이면 _로그인") )
            ],
          ) ,
        )
    ) ;
  } // build end
} // class end

