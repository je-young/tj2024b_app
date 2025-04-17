// * mainapp.dart : 레이아웃 구성 하는 파일
import 'package:flutter/material.dart';
import 'package:flutter_study/app/member/signup.dart';
class MainApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() { return _MainAppState(); }
}
class _MainAppState extends State<MainApp>{

  // 1. 페이지 위젯 리스트 : 여러개 위젯들을 갖는 리스트
  // Widget : 여러 위젯들을 상속하는 상위 위젯(클래스)
  List<Widget> pages = [
    Text("홈 페이지"),
    Text("게시물1 페이지"),
    Text("게시물2 페이지"),
    Signup() //Text("내정보 페이지"),
  ];
  // 2. 페이지 상단 제목 리스트
  List<String> pageTitle = [
    '홈' ,
    '게시물1' ,
    '게시물2' ,
    '내정보(회원가입)'
  ];
  // 3. 현재 클릭된 페이지 번호 : 상태 변수
  // 0 = 홈 , 1 : 게시물 , 2:내정보
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 레이아웃 위젯

        appBar: AppBar( // 상단 메뉴
          title: Row( // 가로배치
              children: [ // 가로배치할 하위 위젯
                // 로컬이미지(플러터) vs 네트워크이미지(Spring서버)
                // 프로젝트폴더 > assets(폴더생성) > images(폴더생성) > logo.jpg
                // 프로젝트폴더 > pubspec.yaml > 'flutter:' 작성된 곳에서 아래와 같이 코드 추가한다 -> 상단 [pub get]새로고침
                // flutter:
                //   assets :
                //     - assets/images/
                Image(
                  image: AssetImage('assets/images/logo.jpg'), // 로컬이미지 : Image(image: AssetImage('로컬이미지경로'))
                  height: 50, // 이미지 세로 크기
                  width: 50, // 이미지 가로 크기
                ),
                SizedBox( width: 20,), // 여백
                Text( pageTitle[ selectedIndex ] ), // 현재 선택된 위젯의 제목 반환
              ]
          ) ,
          backgroundColor: Colors.white, // 배경색
        ), // 헤더 end

        body: pages[ selectedIndex ], // *본문 : 현재 선택된 위젯 반환* // 본문 end

        bottomNavigationBar: BottomNavigationBar(
          // onTap : BottomNavigationBar 에서 해당 하는 버튼 클릭 했을때 발생하는 이벤트속성
          // items 에서 선택된 index 인덱스 번호 반환된다.
          onTap : (index) => setState( () { selectedIndex = index; } ),
          currentIndex: selectedIndex, // 현재 선택된 버튼 번호
          type: BottomNavigationBarType.fixed, // 4개이상일때 아이콘을 고정 크기 설정 , 아이콘이 많아지면 자동으로 확대/축소
          items: [ // 여러개 버튼 위젯들
            BottomNavigationBarItem(icon: Icon(Icons.home) , label : '홈'), // 아이콘 위젯
            BottomNavigationBarItem(icon: Icon(Icons.forum) , label: '게시물1' ),
            BottomNavigationBarItem(icon: Icon(Icons.forum) , label: "게시물2"),
            BottomNavigationBarItem(icon: Icon(Icons.person) , label: "내정보(회원가입)"),
          ],
        ) // 바텀 end

    ); // Scaffold end
  } // build end
} // class end