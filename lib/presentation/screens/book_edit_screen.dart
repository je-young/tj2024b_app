// lib/presentation/screens/book_edit_screen.dart : 책 정보 수정 화면

import 'package:flutter/material.dart';
import 'package:flutter_study/data/models/book.dart'; // Book 모델 import
import 'package:flutter_study/data/services/api_service.dart';

// [1] StatefulWidget 정의
class BookEditScreen extends StatefulWidget {
  final Book book; // [2] 수정할 책의 기존 정보

  // [3] 생성자에서 book 객체 받기
  const BookEditScreen({super.key, required this.book});

  @override
  State<BookEditScreen> createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  // [4] TextEditingController 초기화 시 기존 데이터 사용
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  final _passwordController = TextEditingController(); // 비밀번호는 비워서 시작

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // [5] 컨트롤러에 기존 책 정보 할당
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _descriptionController = TextEditingController(text: widget.book.description);
  }

  @override
  void dispose() {
    // [6] 모든 컨트롤러 dispose
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // [7] 수정 폼 제출 함수
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      try {
        // [7-1] ApiService.updateBook 호출
        final updatedBook = await _apiService.updateBook(
          bookId: widget.book.id, // 기존 책 ID 사용
          title: _titleController.text,
          author: _authorController.text,
          description: _descriptionController.text,
          password: _passwordController.text, // 검증용 비밀번호
        );

        // [7-2] 수정 성공 시: 이전 화면(BookDetailScreen)으로 돌아가며 결과 전달
        if (mounted) {
          // 수정된 Book 객체를 결과로 전달하며 pop
          Navigator.pop(context, updatedBook);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('책 정보가 성공적으로 수정되었습니다.')),
          );
        }
      } catch (e) {
        // [7-3] 수정 실패 시: 에러 메시지 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('수정 실패: ${e.toString().replaceFirst('Exception: ', '')}')),
          );
        }
      } finally {
        // [7-4] 로딩 상태 종료
        if (mounted) { setState(() { _isLoading = false; }); }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 정보 수정'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [8] 각 입력 필드 (BookCreateScreen 과 유사, controller 연결 확인)
              TextFormField(
                controller: _titleController, // 기존 데이터로 초기화된 컨트롤러
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) => (value == null || value.isEmpty) ? '제목을 입력해주세요.' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _authorController, // 기존 데이터로 초기화된 컨트롤러
                decoration: const InputDecoration(labelText: '저자'),
                validator: (value) => (value == null || value.isEmpty) ? '저자를 입력해주세요.' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController, // 기존 데이터로 초기화된 컨트롤러
                decoration: const InputDecoration(labelText: '간단한 소개'),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController, // 비밀번호는 비어있음
                decoration: const InputDecoration(labelText: '비밀번호 (수정하려면 입력)'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return '수정을 위해 비밀번호를 입력해주세요.';
                  if (value.length < 4) return '비밀번호는 4자 이상 입력해주세요.';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // [9] 수정 완료 버튼
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('수정 완료'),
              ), // end ElevatedButton
            ], // end children
          ), // end Column
        ), // end SingleChildScrollView
      ), // end Form
    ); // end Scaffold
  } // end build
} // end _BookEditScreenState