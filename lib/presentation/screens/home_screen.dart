// lib/presentation/screens/home_screen.dart : HomeScreen 클래스 정의

import 'package:flutter/material.dart';
import 'package:flutter_study/data/models/book.dart'; // [1] Book 모델 import
import 'package:flutter_study/data/services/api_service.dart'; // [2] ApiService import
import 'package:flutter_study/presentation/screens/book_detail_screen.dart'; // [13] BookDetailScreen import
import 'package:flutter_study/presentation/screens/book_create_screen.dart'; // [14] BookCreateScreen import


// [3] StatefulWidget 클래스 정의
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} // end HomeScreen

// [4] State 클래스 정의
class _HomeScreenState extends State<HomeScreen> {
  // [5] Future 변수 선언
  late Future<List<Book>> futureBooks;

  // [6] ApiService 인스턴스 생성
  final ApiService apiService = ApiService();

  // [7] initState 메소드
  @override
  void initState() {
    super.initState();
    // [7-1] ApiService의 getBooks() 호출 (내부 구현은 dio로 변경되었지만, 호출 방식은 동일)
    futureBooks = apiService.getBooks();
  } // end initState

  // [11] 새로고침 함수 정의
  Future<void> _refreshBooks() async {
    setState(() {
      // [11-2] API 다시 호출 (내부 구현은 dio로 변경됨)
      futureBooks = apiService.getBooks();
    });
  } // end _refreshBooks

  // [8] build 메소드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('익명 도서 추천'), // 제목
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshBooks),
        ], // end IconButton (새로고침 버튼)
      ), // end AppBar
      body: Center(
        // [9] FutureBuilder
        child: FutureBuilder<List<Book>>(
          future: futureBooks,
          builder: (context, snapshot) {
            // [9-3] 로딩 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } // end if
            // [9-4] 에러 발생
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
            // [9-5] 데이터 로딩 성공
            else if (snapshot.hasData) {
              final books = snapshot.data!;
              // [9-7] 데이터 비어있는 경우
              if (books.isEmpty) {
                return const Text('추천된 책이 아직 없습니다.');
              } // end if
              // [10] RefreshIndicator
              return RefreshIndicator(
                onRefresh: _refreshBooks,
                // [10-2] ListView.builder
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    // [10-5] Card 와 ListTile
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ), // end EdgeInsets
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () { // [10-6] 아이템 탭 이벤트 처리
                          // [13-1] 상세 화면으로 이동 (Navigator.push 사용)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // [13-2] BookDetailScreen 위젯 생성하여 bookId 전달
                              builder: (context) => BookDetailScreen(bookId: book.id),
                            ),
                            // [13-3] 상세 화면에서 돌아 왔을때 목록 새로고침
                          ).then((_) => _refreshBooks()); // 책 삭제 / 수정 후 반영
                        }, // end onTap
                      ), // end ListTile
                    ); // end Card
                  }, // end itemBuilder
                ), // end ListView
              ); // end RefreshIndicator
            } // end if
            // [9-8] 기타 경우
            else {
              return const Text('데이터 없음');
            } // end if
          }, // end builder
        ), // end FutureBuilder
      ), // end Center

      // [12] FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // [14-1] BookCreateScreen 으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookCreateScreen()),
            // [14-2] 등록 화면에서 돌아왔을 때 목록 새로고침
          ).then((_) => _refreshBooks()); // 책 등록 루 바로 반영
        }, // end onPressed
        child: const Icon(Icons.add),
        tooltip: '책 추천 등록',
      ), // end FloatingActionButton
    ); // end Scaffold
  } // end build
} // end _HomeScreenState