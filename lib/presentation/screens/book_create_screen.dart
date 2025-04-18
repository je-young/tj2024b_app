// lib/presentation/screens/book_create_screen.dart : 책 등록 화면


import 'package:flutter/material.dart';
import 'package:flutter_study/data/services/api_service.dart';

// [1] StatefulWidget 정의
class BookCreateScreen extends StatefulWidget {
  const BookCreateScreen({super.key});

  @override
  State<BookCreateScreen> createState() => _BookCreateScreenState();
}

class _BookCreateScreenState extends State<BookCreateScreen> {
  // [2] Form 위젯을 제어하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // [3] 각 입력 필드의 값을 관리하기 위한 TextEditingController
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();

  // [4] API 서비스 인스턴스
  final ApiService _apiService = ApiService();

  // [5] 로딩 상태 관리를 위한 변수
  bool _isLoading = false;

  // [10] 위젯이 화면에서 제거될 때 Controller 정리
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    super.dispose();
  } // end dispose

  // [7] 등록 처리 함수
  Future<void> _submitForm() async {
    // [7-1] Form의 유효성 검사 실행
    if (_formKey.currentState!.validate()) {
      // [7-2] 로딩 상태 시작 및 UI 업데이트
      setState(() {
        _isLoading = true;
      }); // end setState

      try {
        // [7-3] API 호출하여 책 등록
        await _apiService.createBook(
          title: _titleController.text,
          author: _authorController.text,
          description: _descriptionController.text,
          password: _passwordController.text,
        ); // end createBook

        // [7-4] 등록 성공 시: 이전 화면으로 돌아가고 성공 메시지 표시
        if (mounted) { // 위젯이 아직 화면에 있는지 확인
          Navigator.pop(context); // 현재 화면 닫기
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('책 추천이 성공적으로 등록되었습니다.')),
          ); // end SnackBar
        } // end if
      } catch (e) {
        // [7-5] 등록 실패 시: 에러 메시지 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('등록 실패: ${e.toString().replaceFirst('Exception: ', '')}')),
          ); // end SnackBar
        } // end if
      } finally {
        // [7-6] 로딩 상태 종료 및 UI 업데이트 (성공/실패 무관)
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        } // end if
      } // end finally
    } // end if
  } // end _submitForm


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 책 추천 등록'),
      ),
      // [6] Form 위젯으로 전체 감싸기
      body: Form(
        key: _formKey, // Form 키 연결
        child: SingleChildScrollView( // 키보드 올라올 때 화면 스크롤 가능하게
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯 가로 폭 채우기
            children: [
              // [8] 각 입력 필드 (TextFormField 사용)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) { // 유효성 검사
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  } // end if
                  return null;
                }, // end validator
              ), // end TextFormField
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: '저자'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '저자를 입력해주세요.';
                  } // end if
                  return null;
                }, // end validator
              ), // end TextFormField
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '간단한 소개'),
                maxLines: 3, // 여러 줄 입력 가능
                // 소개는 필수가 아닐 수 있으므로 validator 생략 (필요시 추가)
              ), // end TextFormField
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호 (수정/삭제 시 필요)'),
                obscureText: true, // 비밀번호 가리기
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  } // end if
                  if (value.length < 4) { // 간단한 길이 검사 (선택적)
                    return '비밀번호는 4자 이상 입력해주세요.';
                  } // end if
                  return null;
                }, // end validator
              ), // end TextFormField
              const SizedBox(height: 32),
              // [9] 등록 버튼 (ElevatedButton)
              ElevatedButton(
                // 로딩 중일 때는 버튼 비활성화
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox( // 로딩 중일 때 인디케이터 표시
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('등록하기'),
              ), // end ElevatedButton
            ], // end children
          ), // end Column
        ), // end SingleChildScrollView
      ), // end Form
    ); // end Scaffold
  } // end build
} // end _BookCreateScreenState