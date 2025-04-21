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
  late Future<Book> futureBook; // 책 상세 정보 Future

  // [12] 리뷰 목록 Future 대신 State 변수로 관리 시작
  List<Review>? currentReviews; // 리뷰 목록 데이터를 저장할 리스트
  bool _isReviewsLoading = true; // 리뷰 목록 로딩 상태
  String? _reviewsError; // 리부 목록 로딩 에러 메시지

  // [12-1] 리뷰 작성 관련 상태 변수 추가
  final _reviewFormKey = GlobalKey<FormState>(); // 리뷰 작성 폼 키
  final _reviewContentController = TextEditingController(); // 리뷰 내용 컨트롤러
  final _reviewPasswordController = TextEditingController(); // 리뷰 비밀번호 컨트롤러
  bool _isSubmittingReview = false; // 리뷰 제출 로딩 상태

  @override
  void initState() {
    super.initState();
    // [6] 책 상세 정보 로딩 시작
    futureBook = apiService.getBookById(widget.bookId);
    // [12-2] initState에서 리뷰 목록 로드 함수 호출
    _loadReviews();
  } // end initState

  // [13] 리뷰 목록을 비동기적으로 로드하는 함수 정의
  Future<void> _loadReviews() async {
    // [13-1] 이미 로딩 중이거나 위젯이 마운트되지 않았으면 중단
    if (!mounted) return; // _isReviewsLoading 체크 제거 (새로고침을 위해)

    // [13-2] 리뷰 목록 로딩 중 상태로 변경
    setState(() {
      _isReviewsLoading = true; // 로딩 시작 상태 업데이트
      _reviewsError = null; // 이전 에러 초기화
    });

    // [13-3] 리뷰 목록 로드
    try {
      // [13-4] API 서비스를 통해 리뷰 목록 가져오기
      final reviews = await apiService.getReviewsByBookId(widget.bookId);
      // [13-5] // 위젯이 아직 화면에 있다면 상태 업데이트
      if (mounted) {
        setState(() {
          currentReviews = reviews; // 가져온 리뷰 목록 저장
          _isReviewsLoading = false; // 로딩 종료 상태 업데이트
        });
      }
    } catch (e) {
      // [13-6] 에러 발생 시 위젯이 화면에 있다면 에러 상태 업데이트
      if (mounted) {
        setState(() {
          _reviewsError = e.toString().replaceFirst(
            'Exception: ',
            '',
          ); // 에러 메시지 저장
          _isReviewsLoading = false; // 로딩 종료 상태 업데이트
        }); // end setState
      } // end if
    } // end try catch
  } // end _loadReviews

  // [14] 리뷰 작성 폼을 제출하는 함수 정의
  Future<void> _submitReview() async {
    // [14-1] 폼 유효성 검사
    if (_reviewFormKey.currentState!.validate()) {
      // [14-2] 위젯이 화면에 있다면 로딩 상태 시작
      if (!mounted) return;
      setState(() {
        _isSubmittingReview = true;
      });

      try {
        // [14-3] API 서비스를 통해 리뷰 생성 요청
        await apiService.createReview(
          bookId: widget.bookId,
          content: _reviewContentController.text,
          password: _reviewPasswordController.text,
        );

        // [14-4] 성공 시 처리 (위젯이 화면에 있을 때만)
        _reviewContentController.clear(); // 내용 입력 필드 비우기
        _reviewPasswordController.clear(); // 비밀번호 입력 필드 비우기
        FocusScope.of(context).unfocus(); // 키보드 숨기기

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('리뷰가 성공적으로 등록되었습니다.')));
        // [14-5] 리뷰 목록 새로고침 (상태 업데이트 포함)
        _loadReviews();
      } catch (e) {
        // [14-6] 실패 시 처리 (위젯이 화면에 있을 때만)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '리뷰 등록 실패: ${e.toString().replaceFirst('Exception: ', '')}',
              ), // end Text
            ), // end SnackBar
          ); // end showSnackBar
        } // end if
      } finally {
        // [14-7] 최종 처리 (위젯이 화면에 있을 때만)
        if (mounted) {
          setState(() {
            _isSubmittingReview = false; // 로딩 상태 종료
          }); // end setState
        } // end if
      } // end finally
    } // end if
  } // end _submitReview

  // [19] 비밀번호 입력을 위한 공통 다이얼로그 함수
  Future<String?> _showPasswordDialog({required String title, required String content}) async {
    // [19-1] 비밀번호 입력을 받을 TextEditingController 생성
    final passwordController = TextEditingController();

    // [10-2] showDialog를 통해 다이얼로그 표시 (비밀번호 입력받기)
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // 다이얼로그 바깥 탭해도 닫히지 않음
      builder: (BuildContext context) {
        // [10-3] AlertDialog 위젯 반환
        return AlertDialog(
          title: Text(title), // 다이얼로그 제목 표시
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: content),
            autofocus: true, // 다이얼로그 열릴 때 자동으로 포커스
          ), // end TextField
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 비밀번호 없이 닫기 (null 반환)
              },
            ), // end TextButton
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                // 입력된 비밀번호와 함께 닫기
                Navigator.of(context).pop(passwordController.text);
              }, // end onPressed
            ), // TextButton
          ], // end <widget>[]
        ); // AlertDialog
      }, // end builder
    ).whenComplete(() => passwordController.dispose()); // 다이얼로그 닫힐 때 컨트롤러 정리
  } // end async _showPasswordDialog

  // [15] 위젯이 제거될 때 컨트롤러 정리
  @override
  void dispose() {
    _reviewContentController.dispose(); // 리뷰 내용 입력 필드 제거
    _reviewPasswordController.dispose(); // 리뷰 비밀번호 입력 필드 제거
    super.dispose();
  } // end dispose

  // 화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 상세 정보'), // AppBar 제목
      ), // end AppBar
      // [16] 화면 다른 곳 탭 시 키보드 숨기기 및 스크롤 가능하게
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
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
                    ); // 로딩 중 // end Center
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('오류: ${snapshot.error}'),
                    ); // 에러 발생 // end Center
                  } else if (snapshot.hasData) {
                    final book = snapshot.data!;
                    // [9] 책 정보 표시
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ), // end Text

                        const SizedBox(height: 8),

                        Text(
                          '저자: ${book.author}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ), // end Text

                        const SizedBox(height: 8),

                        Text(
                          '추천일: ${book.createdAt.toLocal().toString().substring(0, 10)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ), // end Text

                        const SizedBox(height: 16),

                        Text(book.description),
                        const SizedBox(height: 24),
                        const Divider(), // 구분선
                      ], // end children
                    ); // end Column
                  } else {
                    return const Center(child: Text('책 정보를 불러올 수 없습니다.'));
                  } // end if
                }, // end builder
              ), // end FutureBuilder
              // --- [16-1] 리뷰 섹션 제목 ---
              Text('리뷰 목록', style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: 16),

              // [16-2] 리뷰 목록을 표시하는 위젯 호출 (상태 기반)
              _buildReviewList(),
              const SizedBox(height: 24),
              const Divider(),

              // --- [16-3] 리뷰 작성 폼 섹션 ---
              Text('리뷰 작성하기', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              // [16-4] 리뷰 작성 폼을 생성하는 위젯 호출
              _buildReviewForm(),

              // TODO: 책 수정/삭제 버튼 추가 (5, 6단계)
            ], // end children
          ), // Column
        ), // SingleChildScrollView
      ), // GestureDetector
    ); // end Scaffold
  } // end build

  // [17] 현재 상태에 따라 리뷰 목록 UI를 생성하는 함수
  Widget _buildReviewList() {
    if (_isReviewsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_reviewsError != null) {
      return Center(child: Text('리뷰 로딩 오류: $_reviewsError'));
    } else if (currentReviews == null || currentReviews!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text('아직 작성된 리뷰가 없습니다.'),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentReviews!.length,
        itemBuilder: (context, index) {
          final review = currentReviews![index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              // [17-1] 삭제 버튼 공간 확보 위해 Row 추가
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [17-2] 내용 영역
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.content),
                        const SizedBox(height: 4),
                        Text(
                          '작성일: ${review.createdAt.toLocal().toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ], // end children
                    ), // end Column
                  ), // end Expanded
                  // TODO: [5단계] 리뷰 삭제 버튼 추가 영역
                ], // end children
              ), // end Row
            ), // end Padding
          ); // end Card
        }, // end itemBuilder
      ); // end ListView.builder
    } // end else
  } // end _buildReviewList

  // [18] 리뷰 작성 폼 UI를 생성하는 함수
  Widget _buildReviewForm() {
    return Form(
      key: _reviewFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // [18-1] 리뷰 내용 입력 필드
          TextFormField(
            controller: _reviewContentController,
            decoration: const InputDecoration(
              labelText: '리뷰 내용',
              hintText: '책에 대한 감상을 남겨주세요.',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator:
                (value) =>
                    (value == null || value.isEmpty) ? '리뷰 내용을 입력해주세요.' : null,
          ), // end TextFormField

          const SizedBox(height: 16),

          // [18-2] 비밀번호 입력 필드
          TextFormField(
            controller: _reviewPasswordController,
            decoration: const InputDecoration(
              labelText: '비밀번호 (삭제 시 필요)',
              border: OutlineInputBorder(),
            ), // end InputDecoration
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
              if (value.length < 4) return '비밀번호는 4자 이상 입력해주세요.';
              return null;
            }, // end validator
          ), // end TextFormField

          const SizedBox(height: 16),

          // [18-3] 리뷰 등록 버튼
          ElevatedButton(
            onPressed: _isSubmittingReview ? null : _submitReview,
            child:
                _isSubmittingReview
                    // [18-4] 등록 중일때 로딩 인디케이터 표시
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ), // end CircularProgressIndicator
                    ) // end SizedBox
                    : const Text('리뷰 등록'),
          ), // end ElevatedButton
        ], // end children
      ), // end Column
    ); // end Form
  } // end _buildReviewForm
} // end _BookDetailScreenState
