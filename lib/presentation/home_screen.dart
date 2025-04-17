// lib/presentation/screens/home_screen.dart : HomeScreen 클래스 정의

import 'package:flutter/material.dart';
import '../../data/models/book.dart'; // [1] Book 모델 import (동일)
import '../../data/services/api_service.dart'; // [2] ApiService import (동일)

// [3] StatefulWidget 클래스 정의 (동일)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} // end HomeScreen

// [4] State 클래스 정의 (동일)
class _HomeScreenState extends State<HomeScreen> {
  // [5] Future 변수 선언 (동일)
  late Future<List<Book>> futureBooks;

  // [6] ApiService 인스턴스 생성 (동일)
  final ApiService apiService = ApiService();

  // [7] initState 메소드 (동일)
  @override
  void initState() {
    super.initState();
    // [7-1] ApiService의 getBooks() 호출 (내부 구현은 dio로 변경되었지만, 호출 방식은 동일)
    futureBooks = apiService.getBooks();
  } // end initState

  // [11] 새로고침 함수 정의 (동일)
  Future<void> _refreshBooks() async {
    setState(() {
      // [11-2] API 다시 호출 (내부 구현은 dio로 변경됨)
      futureBooks = apiService.getBooks();
    });
  } // end _refreshBooks

  // [8] build 메소드 (동일)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('익명 도서 추천 (Dio)'), // 제목에 Dio 추가 (선택적)
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshBooks),
        ],
      ), // end AppBar
      body: Center(
        // [9] FutureBuilder (동일)
        child: FutureBuilder<List<Book>>(
          future: futureBooks,
          builder: (context, snapshot) {
            // [9-3] 로딩 중 (동일)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } // end if
            // [9-4] 에러 발생 (동일)
            else if (snapshot.hasError) {
              print(snapshot.error);
              // DioException 의 경우 좀 더 상세한 에러 메시지를 표시할 수 있음
              String errorMessage = '오류가 발생했습니다.';
              if (snapshot.error is Exception) {
                errorMessage = (snapshot.error as Exception)
                    .toString()
                    .replaceFirst('Exception: ', '');
              } // end if
              return Padding(
                // 에러 메시지가 잘 보이도록 Padding 추가
                padding: const EdgeInsets.all(16.0),
                child: Text(errorMessage, textAlign: TextAlign.center),
              ); // end Padding
            } // end if
            // [9-5] 데이터 로딩 성공 (동일)
            else if (snapshot.hasData) {
              final books = snapshot.data!;
              // [9-7] 데이터 비어있는 경우 (동일)
              if (books.isEmpty) {
                return const Text('추천된 책이 아직 없습니다.');
              } // end if
              // [10] RefreshIndicator (동일)
              return RefreshIndicator(
                onRefresh: _refreshBooks,
                // [10-2] ListView.builder (동일)
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    // [10-5] Card 와 ListTile (동일)
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ), // end EdgeInsets
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // [10-6] 아이템 탭 이벤트 처리 (2단계에서 구현)
                          print(
                            'Tapped on book: ${book.title} (ID: ${book.id})',
                          ); // end print
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${book.title} 선택됨 (상세보기 구현 예정)'),
                            ), // end SnackBar
                          ); // end showSnackBar
                        }, // end onTap
                      ), // end ListTile
                    ); // end Card
                  }, // end itemBuilder
                ), // end ListView
              ); // end RefreshIndicator
            } // end if
            // [9-8] 기타 경우 (동일)
            else {
              return const Text('데이터 없음');
            } // end if
          }, // end builder
        ), // end FutureBuilder
      ), // end Center
      // [13] FloatingActionButton (동일)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Go to create book screen');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('책 등록 화면 이동 구현 예정')));
        }, // end onPressed
        child: const Icon(Icons.add),
        tooltip: '책 추천 등록',
      ), // end FloatingActionButton
    ); // end Scaffold
  } // end build
} // end _HomeScreenState
