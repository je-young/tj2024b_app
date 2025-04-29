import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/app/product/productView.dart';


class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
} // end ProductList

class _ProductListState extends State<ProductList> {
  // 1.
  int cno = 0; // 카테고리 번호 갖는 상태변수 , 초기값 0
  int page = 1; // 현재 조회 중인 페이지 번호 갖는 상태변수 , 초기값 1
  List<dynamic> productList = []; // 자바서버로 부터 조회한 제품(DTO) 목록 상태변수
  final dio = Dio(); // 자바서버 와 통신 객체
  String baseUrl = 'http://192.168.40.107:8080'; // 기본 자바서버의 url 정의 // 환경에 따라 ip 변경
  // * 현재 스크롤의 상태(위치/크기 등)를 감지하는 컨트롤러
  // * 무한 스크롤( 스크롤이 거의 바닥에 존재했을때 새로운 자료 요청 )
  // .position : 현재 스크롤의 위치 반환 , .position.pixels : 위치를 픽셀로 반환.
  // .position.maxScrollExtent : 전체 화면의 스크롤 최대 크기
  final ScrollController scrollController = ScrollController();

  // 2. 현제 위젯 생명주기 : 위젯이 처음으로 열렸을때 1번 실행
  @override // (1) 자바서버에게 자료요청 (2) 스크롤에 리스너(이벤트) 추가.
  void initState() {
    onProductAll(page); // 현재 페이지 전달
    scrollController.addListener(onScroll); // .addListener( 이벤트 ) : 스크롤의 이벤트(함수) 리스터 추가
  } // end initState

  // 3. 자바서버에게 자료요청 메소드
  void onProductAll(int currentPage) async {
    try {
      final response = await dio.get('${baseUrl}/product/all?&page=${currentPage}'); // 현재페이지(page) 매개변수로 보낸다.
      setState(() {
        page = currentPage; // 증가된 현재페이지를 상태변수에 반영
        if( page == 1 ){ // 만약에 첫페이지 이면 자료 *대입*
          productList = response.data['content'];
        }else if( page >= response.data['totalPages'] ){ // 만약에 현재페이지수가 전체페이지수 보다 이상이면
          page = response.data['totalPages']; // 현재페이지수를 전체페이지수로 변경
        }else{ // 다음페이지 자료가 존재하면 *추가* , .addAll()
          productList.addAll( response.data['content'] );
        }
        print( productList );
        print( response.data );
      });
    }catch(e ){ print( e ); }
  } // end onProductAll

  // 4. 스크롤의 리스터(이벤트) 추가 메소드
  void onScroll() {
    // - 만약에 현재 스크롤의 위치가 거의( 적당하게 100 ~ 200 사이 ) 끝에 도달 했을때
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150) {
      onProductAll(page + 1); // 스크롤이 거의 바닥에 도달했을때 page 를 1증가하여 다음 페이지 자료 요청한다.
    }
  } // end onScroll

  // 5. 위젯이 반환하는 화면들
  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      // 만약에 제품 목록이 비어 있으면
      return Center(child: Text("조회된 제품이 없습니다."));
    }
    // 제품 목록이 있으면
    // - ListView.builder : 여러개 아이템/항목/위젯 들을 리스트 형식으로 출력하는 위젯
    return ListView.builder(
      controller: scrollController, // <--- * ListView 에 스크롤 컨트롤러
      itemCount: productList.length, // 목록의 항목 개수 <===> 제품 목록의 개수
      itemBuilder: (context, index) { // 목록의 항목 개수 만큼 반복문
        // (1) 각 index 번째 제품 꺼내기
        final product = productList[index];
        // (2) 각 제품의 이미지 리스트 추출
        final List<dynamic> images = product['images'];
        // (3) 만약에 이미지가 존재하면 대표이미지(1개)추출 없으면 기본이미지 추출
        String imageUrl;
        if( images.isEmpty ) {
          imageUrl = "$baseUrl/upload/default.jpg";
        } else {
          imageUrl = "$baseUrl/upload/${ images[0] }";
        }
        // (4) 위젯
        return InkWell( // 해당 위젯을 클릭(탭:모바일 터치) 하면 '상세 페이지'로 이동 구현
          onTap: () => { // 만약에 하위 위젯을 클릭했을때 이벤트 발생
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView( pno: product['pno'],) // 상세 페이지로 이동
            ) // end MaterialPageRoute
          ) // end Navigator

          },
          child: Card(
            margin: EdgeInsets.all(15), // 바깥 여백
            child: Row( // 가로 배치
              children: [ // 가로 배치할 위젯들

                Container( // 하위 요소를 담을 박스(div)
                  width: 100, height: 100, // 가로, 세로 사이즈
                  child: Image.network( // 웹 이미지 출력 ( 이미지 위젯 )
                      imageUrl, // 이미지 경로
                      fit: BoxFit.cover, // 만약에 이미지가 구역보다 크면 비율유지 // Image.network
                  ), // end Image
                ), // end Container

                SizedBox(width: 20,), // 여백

                Expanded(child: Column( // 그외 구역
                  children: [
                    Text(product['pname'] , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),), // 제품명
                    SizedBox(height: 8,),
                    Text("가격 : ${ product['pprice'] }" , style: TextStyle(fontSize: 16 , color: Colors.red),), // 가격
                    Text("카케고리 : ${ product['cname'] }"), // 카테고리
                    Text("조회수 : ${ product['pview'] }"), // 조회수
                  ], // end children
                )) // end Column
              ], // end children
            ), // end Row
          ), // end Card
        ); // end InkWell
      }, // end itemBuilder
    ); // end return
  } // end build
} // end _ProductListState

