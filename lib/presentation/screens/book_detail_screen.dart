// lib/presentation/screens/book_detail_screen.dart : 책 상세 정보 화면


import 'package:flutter/material.dart';
import 'package:flutter_study/data/models/book.dart';
import 'package:flutter_study/data/models/review.dart';
import 'package:flutter_study/data/services/api_service.dart';

// [1] StatefulWidget 정의
class BookDetailScreen extends StatefulWidget {
  final int bookId; // [2] 이전 화면에서 전달받을 책 ID

  // [3] 생성자에서 bookId 받기
  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
} // end BookDetailScreen

class _BookDetailScreenState extends State<BookDetailScreen> {
  // [4] ApiService 인스턴스 생성
  final ApiService apiService = ApiService();

  // [5] Future 변수 선언 (책 상세 정보, 리뷰 목록)
  late Future<Book> futureBook;
  late Future<List<Review>> futureReviews;

  @override
  void initState() {
    super.initState();
    // [6] initState에서 API 호출 시작 (ID는 widget.bookId 로 접근)
    futureBook = apiService.getBookById(widget.bookId);
    futureReviews = apiService.getReviewsByBookId(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 상세 정보'), // AppBar 제목
      ),
      body: SingleChildScrollView(
        // [7] 내용이 길어질 수 있으므로 스크롤 가능하게
        padding: const EdgeInsets.all(16.0), // 전체적인 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // --- 책 상세 정보 섹션 ---
            // [8] FutureBuilder로 책 상세 정보 로딩 및 표시
            FutureBuilder<Book>(
              future: futureBook,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // 로딩 중
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류: ${snapshot.error}')); // 에러 발생
                } else if (snapshot.hasData) {
                  final book = snapshot.data!;
                  // [9] 책 정보 표시
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '저자: ${book.author}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '추천일: ${book.createdAt.toLocal().toString().substring(0, 10)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 16),

                      Text(book.description),
                      const SizedBox(height: 24),
                      const Divider(), // 구분선

                      Text(
                        '리뷰 목록',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 16),

                    ], // end children
                  ); // end Column
                } else {
                  return const Center(child: Text('책 정보를 불러올 수 없습니다.'));
                } // end if
              }, // end builder
            ), // end FutureBuilder

            // --- 리뷰 목록 섹션 ---
            // [10] FutureBuilder로 리뷰 목록 로딩 및 표시
            FutureBuilder<List<Review>>(
              future: futureReviews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 책 정보 로딩 중일 때는 리뷰 로딩 표시 안 함 (선택적)
                  // 이미 위에서 로딩 돌고 있으므로 여기선 크기 없는 위젯 반환 가능
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  // 책 정보가 정상 로드된 후 리뷰 로드 에러 발생 시
                  return Center(child: Text('리뷰 로딩 오류: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final reviews = snapshot.data!;
                  if (reviews.isEmpty) {
                    return const Center(
                      child: Text('아직 작성된 리뷰가 없습니다.'),
                    ); // 리뷰 없음
                  } // end if
                  // [11] 리뷰 목록 표시 (ListView 또는 Column 사용)
                  return ListView.builder(
                    shrinkWrap: true, // SingleChildScrollView 안에서 사용 시 필요
                    physics: const NeverScrollableScrollPhysics(), // 부모 스크롤 사용
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        // 각 리뷰를 카드로 표시
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.content),
                              const SizedBox(height: 4),
                              Text(
                                '작성일: ${review.createdAt.toLocal().toString().substring(0, 16)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              // TODO: 리뷰 삭제 버튼 추가 (5단계)
                            ], // end children
                          ), // end Column
                        ), // end Padding
                      ); // end Card
                    }, // end itemBuilder
                  ); // end ListView
                } else {
                  return const Center(child: Text('리뷰 정보를 불러올 수 없습니다.'));
                } // end if
              }, // end builder
            ), // end FutureBuilder
            // TODO: 리뷰 작성 버튼/영역 추가 (4단계)
            // TODO: 책 수정/삭제 버튼 추가 (5, 6단계)
          ], // end children
        ), // end Column
      ), // end SingleChildScrollView
    ); // end Scaffold
  } // end build
} // end _BookDetailScreenState
