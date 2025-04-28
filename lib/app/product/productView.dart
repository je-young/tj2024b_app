import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  // [부모위젯]

  // (1) 하나의 필드를 갖는 생성자.
  /*
  int pno; // - 필드/멤버변수
  ProductView(this.pno); // 생성자
  */
  // 오버로딩 지원하지 않는다. : 여러개 생성자를 가질수 없다.

  // (2) * 여러개의 필드를 갖는 생성자. *
  int? pno; // 타입? : null 포함한다 뜻
  String? pname;

  ProductView({this.pno, this.pname});

  @override
  State<StatefulWidget> createState() {
    // print( pno ); // [확인용]
    return _ProductViewState();
  }
} // end ProductView

class _ProductViewState extends State<ProductView> {
  // [자식위젯]

  // 1.
  Map<String, dynamic> product = {}; // 제품 1개를 저장하는 상태변수
  final dio = Dio();
  final baseUrl = "http://localhost:8080"; // 환경에 따라 변경
  // 2. 생명주기
  @override // (1) pno 에 해당하는 제품 정보 요청
  void initState() {
    onView();
  }

  // 3. 제품 요청
  void onView() async {
    try {
      // * 직계 상위 부모 위젯의 접근 : widget.필드명  , widget.메소드명()
      final response = await dio.get("$baseUrl/product/view?pno=${widget.pno}");
      if (response.data != null) {
        setState(() {
          product = response.data;
          print(product); // [확인]
        });
      }
    } catch (e) {
      print(e);
    }
  } // end onView

  // 4. 화면 반환
  @override
  Widget build(BuildContext context) {
    // 1. 만약에 제품 정보가 없으면 로딩위젯( CircularProgressIndicator() )
    if (product.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // 2. 이미지 추출
    final List<dynamic> images = product['images'];

    // 3. 이미지 상태에 따라 위젯 만들기
    Widget imageSection;
    if (images.isEmpty) { // 이미지가 존재하지 않으면
      imageSection = Container(
        height: 300, // 높이
        alignment: Alignment.center, // 가운데 정렬
        child: Image.network("$baseUrl/upload/default.jpg", fit: BoxFit.cover),
      ); // end Container
    } else {
      // 이미지가 존재하는 경우
      imageSection = Container(
        height: 300, // 높이
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 가로 스크롤
          itemCount: images.length, // 목록의 항목 개수
          itemBuilder: (context, index) {
            // 목록의 항목 개수 만큼 반복문
            String imageUrl =
                "$baseUrl/upload/${images[index]}"; // index 번째 이미지
            return Padding(
              padding: EdgeInsets.all(5),
              child: Image.network(imageUrl),
            ); // end Padding
          }, // end itemBuilder
        ), // end ListView
      ); // end Container
    } // end else

    return Scaffold(
      appBar: AppBar(title: Text("제품 상세 정보")), // end AppBar
      // 3. 본문
      body: SingleChildScrollView(
        // 내용이 길어지면 스크롤 제공하는 위젯
        padding: EdgeInsets.all(15), // 안쪽여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽정렬
          children: [
            /* 이미지 위젯 */
            imageSection,
            /* end 이미지 위젯 */
            SizedBox(height: 24),
            Text(
              product['pname'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Text(
              "${product['pprice']}원",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Divider(), // 구분선
            SizedBox(height: 10),
            Row(
              // 가로배치
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝에 배치
              children: [
                Text("카테고리: ${product['cname']}"),
                Text("조회수: ${product['pview']}"),
              ], // end children
            ), // end Row
            SizedBox(height: 10),
            Text("판매자: ${product['memail']}"),
            SizedBox(height: 20),
            Text(
              "제품설명",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(product['pcontent']),
          ], // end children
        ), // end Column
      ), // end body
    ); // end Scaffold
  } // end build
} // end _ProductViewState
