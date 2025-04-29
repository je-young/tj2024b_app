import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductRegister();
  } // end createState
} // end ProductRegister

class _ProductRegister extends State<ProductRegister> {
  // 1. 컨트롤러 생성
  final TextEditingController pnameController = TextEditingController(); // 제품명
  final TextEditingController pcontentController =
  TextEditingController(); // 제품설명
  final TextEditingController ppriceController =
  TextEditingController(); // 제품가격
  int? cno = 1; // 카테고리 번호 // 드롭다운
  final dio = Dio();
  final String baseUrl = "http://192.168.40.107:8080"; // 환경에 따라 변경
  List<dynamic> categoryList = [
  ]; // 카테고리 목록 [ { cno : 1, cname : "전자~" } , { cno : 2, cname : "~~" } ]

  @override  // 위젯이 로드될때 딱 1번 실행 함수.
  void initState() { onCategory(); } // end initState

  // 4. 이미지 피커 : 사용자의 파일을 플러터로 가져오기
    // 1. pubspec.yaml 파일의 dependencies 추가 : image_picker: ^1.1.2
  List<XFile> selectedImage = []; // 현재 선택된 이미지들을 저장하는 리스트
  void onSelectImage() async { // 이미지 선택 이벤트 함수
    try {
      ImagePicker picker = ImagePicker(); // 이미지 피커 객체 생성 , .pickMultiImage() 이미지 여러개 , .pickImage() 이미지 한개
      List<XFile> pickedFiles = await picker.pickMultiImage(); // 사용자가 선택한 이미지들을 XFILE 파일으로 반환한다.
        // XFile 인터페이스는 이미지들을 조작할 수 있는 메소드 제공한다.
      if (pickedFiles.isNotEmpty) { // 선택된 이미지가 존재하면 상태변수에 저장한다.
        setState(() { selectedImage = pickedFiles; });
      } // end if
    } catch (e) { print(e); }
  } // end onSelectImage

  // 3. 카테고리 조회 요청 함수 (+위젯이 로드될때 실행)
  void onCategory() async {
    try {
      final response = await dio.get("$baseUrl/product/category");
      setState(() { categoryList = response.data; print(categoryList); });
    } catch (e) { print(e); }
  } // end onCategory

  // 2. 제품 등록 요청 함수 ( + FormData )
  void onRegister() async {
    try {
      // 1. (현재 로그인된) 토큰 확인
      final prefs = await SharedPreferences.getInstance(); // 전역변수 객체 호출
      final token = prefs.getString('token'); // 전역변수 객체에 저장된 key 값 호출
      if (token == null) { print("로그인후 가능합니다."); return; } // 비로그인 상태
      // 2. 폼데이터 구성 ( + 첨부파일 )
      FormData formData = FormData(); // 전송한 자료들을 바이너리(바이트) 타입으로 변경 // 이유 : 대용량
      // formData.fields.add( MapEntry("필드명", "값") ); // 필드명은 자바의 DTO 필드명 과 동일해야함.
      formData.fields.add( MapEntry("pname", pnameController.text), ); // 폼에 입력받은 제품명 대입
      formData.fields.add( MapEntry("pcontent", pcontentController.text), ); // 폼에 입력받은 제품설명 대입
      formData.fields.add( MapEntry("pprice", ppriceController.text), ); // 폼에 입력받은 제품가격 대입
      formData.fields.add(MapEntry("cno", '${cno}')); // 폼에 입력받은 카테고리번호 대입
      // (*) 현재 선택된 이미지들을 formData 에 담아주기.
      for( XFile xFile in selectedImage ){
        // XFile 의 path : 파일경로 , Xfile 의 name : 파일이름 을 // dio의 multipartFile 이용하여 파일객체 만들기.
        // XFile ---> MultipartFile 변환
        final file = await MultipartFile.fromFile( xFile.path, filename: xFile.name );
        // dio 의 multipartFile 객체를 폼 대입 , XFile 자체는 전송이 불가능 하다.
        formData.files.add( MapEntry("files", file) ); // files 라는 이름으로 file(multipartFile)
      } // end for

      // 3. DIO 요청
      dio.options.headers["Authorization"] = token; // 3-1 : HTTP Header( 통신정보 )에 인증 정보 포함.
      final response = await dio.post( "$baseUrl/product/register", data: formData, );
      // 4. DIO 응답 처리
      if (response.statusCode == 201 && response.data == true) { print("제품등록 성공");}
    } catch (e) { print(e); }
  } // end productRegister

  // 5. 화면 반환
  @override
  Widget build(BuildContext context) {
    // + 카테고리 드롭다운 위젯 함수
    Widget CategoryDropdown(){
      // return DropdownButton( items : items , onChanged: onChanged );
      // items : 드롭다운 안에 들어가는 여러개의 항목들
      // 리스트.map( (반복변수){ return } ).toList()
      // onChanged : 드롭다운 값의 선택이 변경 되었을때 이벤트 발생함수.
      return DropdownButtonFormField( // 제네릭 <int> : value 에 들어가는 값 타입
          value: cno, // 카테고리 번호 초기값
          hint: Text("카테고리 선택") , // 가이드라인
          decoration: InputDecoration( border: OutlineInputBorder() ), // 바깥 테두리
          items: categoryList.map( (category){
            return DropdownMenuItem<int>( // 제네릭 <int> : value 에 들어가는 값 타입
              value: category['cno'],  // 드롭다운에서 값 선택시 반환되는 값
              child: Text( category['cname'] ) ,  // 드롭다운 화면에 보이는 텍스트
            );
          }).toList(),
          onChanged: ( value ){ setState(() { cno = value;  });} // 변경된/선택된 값을 cno에 대입
      ); // end DropdownButtonFormField
    } // end CategoryDropdown

    // (+) 선택한 이미지를 미리보기 제공 함수
    Widget ImagePreview(){
      if( selectedImage.isEmpty ){ return SizedBox(); }//만약에 선택된 이미지가 없으면 빈칸
      return Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal , // List 방향 , 기본값이 세로 , 가로 설정
          itemCount: selectedImage.length, // 이미지 개수만큼 반복
          itemBuilder: (context, index){ // 반복문
            final XFile xFile = selectedImage[index]; // index 번째 xfile 꺼내기
            return Padding(
                padding: EdgeInsets.all(5), // 여백
              child: SizedBox(
                width: 100, height: 100, // 이미지 사이즈 설정
                child: Image.file( File(xFile.path)), // 현재 index 번째의 xfile를 이미지로 변환
              ), // end SizedBox
            ); // end Padding
          }, // end itemBuilder
        ), // end ListView.builder
      ); // end Container
    } // end ImagePreview

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            CategoryDropdown(),
            SizedBox( height: 10 , ),

            TextField(
              controller: pnameController,
              decoration: InputDecoration( labelText: "제품명" , border: OutlineInputBorder() ),
            ),
            SizedBox( height: 10 , ),

            TextField(
              controller: pcontentController,
              decoration: InputDecoration( labelText: "제품 설명" , border: OutlineInputBorder() ),
            ),
            SizedBox( height: 10 , ),

            TextField(
              controller: ppriceController,
              decoration: InputDecoration( labelText: "제품 가격" , border: OutlineInputBorder() ),
              keyboardType: TextInputType.number, // 키보드 기본 타입을 설정
            ),
            SizedBox( height: 10 , ),
            TextButton.icon(
              icon: Icon( Icons.add_a_photo ),
              label: Text("이미지 선택 : ${ selectedImage.length }개 "),
              onPressed: onSelectImage,
            ), // end TextButton.icon
            ImagePreview(),
            SizedBox( height: 10 , ),
            ElevatedButton(onPressed: onRegister, child: Text("제품등록")),
          ], // end children
        ), // end Column
      ), // end Container
    ); // end Scaffold
  } // end build
} // end ProductRegister


