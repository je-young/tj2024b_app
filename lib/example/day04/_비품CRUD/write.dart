// lib/example/day04/_비품CRUD/write.dart
// 비품 등록 화면

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextInputFormatter 사용
// import '../constants/api_constants.dart'; // API 상수 import 또는 직접 사용

// API 기본 URL (필요시 별도 파일로 분리 권장)
const String API_BASE_URL = 'http://localhost:8080/api/supplies'; // ✅ dio를 이용한 웹브라우저 IP 주소
//const String API_BASE_URL = 'http://10.0.2.2:8080/api/supplies'; // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
//const String API_BASE_URL = 'https://accurate-keriann-jey2965-01e9656d.koyeb.app/api/supplies'; // ✅ 배포후 IP 주소

// 상태가 있는 위젯
class AddSupplyScreen extends StatefulWidget {
  @override
  _AddSupplyScreenState createState() => _AddSupplyScreenState();
}

class _AddSupplyScreenState extends State<AddSupplyScreen> {
  // Form 위젯의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();
  // 각 TextField를 제어하기 위한 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final Dio dio = Dio(); // Dio 인스턴스
  bool _isSaving = false; // 저장 요청 진행 중 상태

  // State 객체 소멸 시 컨트롤러 리소스 해제 (메모리 누수 방지)
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // 비품 등록 요청 함수 (비동기)
  Future<void> _addSupply() async {
    // Form 유효성 검사 실행
    if (_formKey.currentState!.validate()) {
      // 유효성 검사 통과 시
      setState(() { _isSaving = true; }); // 저장 중 상태로 변경
      try {
        // 서버에 보낼 데이터 Map 생성
        final data = {
          'name': _nameController.text, // 이름 컨트롤러 값
          'description': _descriptionController.text, // 설명 컨트롤러 값
          'quantity': int.tryParse(_quantityController.text) ?? 0, // 수량 컨트롤러 값 (숫자 변환)
        };
        // Dio POST 요청 보내기
        final response = await dio.post('$API_BASE_URL', data: data);

        // 성공 응답(201 Created) 처리
        if (response.statusCode == 201) {
          if (!mounted) return; // 위젯이 화면에 있는지 확인
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비품 등록 성공!')));
          Navigator.pop(context); // 성공 시 이전 화면(Home)으로 돌아가기
        } else {
          // 서버에서 다른 상태 코드 응답 시
          throw Exception('Failed to add supply (status: ${response.statusCode})');
        }
      } catch (e) { // 네트워크 오류 등 예외 발생 시
        print('등록 에러: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
      } finally { // 성공/실패 여부와 관계없이 항상 실행
        if (!mounted) return;
        setState(() { _isSaving = false; }); // 저장 중 상태 해제
      }
    } // end if (validate)
  } // end _addSupply

  // UI 구성 (build 메소드)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('새 비품 등록')), // 상단 앱 바
      body: Padding( // 전체 여백
        padding: const EdgeInsets.all(16.0),
        // Form 위젯: 유효성 검사를 위해 사용
        child: Form(
          key: _formKey, // Form 상태 관리를 위한 키 연결
          child: ListView( // 입력 필드가 많거나 키보드가 올라올 때 스크롤 가능하도록 ListView 사용
            children: [
              // 비품명 입력 필드
              TextFormField(
                controller: _nameController, // 컨트롤러 연결
                decoration: InputDecoration(
                  labelText: '비품명 *', // 레이블 (*) 필수 표시
                  border: OutlineInputBorder(), // 테두리
                  hintText: '예: 노트북, 모니터', // 입력 예시
                ),
                validator: (value) { // 유효성 검사기
                  if (value == null || value.isEmpty) {
                    return '비품명을 입력하세요.'; // 비어있으면 에러 메시지 반환
                  }
                  return null; // 유효하면 null 반환
                },
              ),
              SizedBox(height: 16), // 간격

              // 비품 설명 입력 필드
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '비품 설명',
                  border: OutlineInputBorder(),
                  hintText: '예: 15인치, i7, 16GB RAM',
                ),
                maxLines: 3, // 여러 줄 입력 가능
                // 설명은 필수가 아니므로 validator 생략
              ),
              SizedBox(height: 16),

              // 수량 입력 필드
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: '수량 *',
                  border: OutlineInputBorder(),
                  hintText: '예: 10',
                ),
                keyboardType: TextInputType.number, // 숫자 키패드 표시
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly // 숫자만 입력 가능하도록 제한
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '수량을 입력하세요.';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return '0 이상의 유효한 숫자를 입력하세요.'; // 음수 또는 숫자 아닌 값 방지
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // 등록 버튼
              ElevatedButton(
                // _isSaving이 true이면 버튼 비활성화 (onPressed: null)
                onPressed: _isSaving ? null : _addSupply,
                child: _isSaving // _isSaving 상태에 따라 다른 위젯 표시
                    ? SizedBox( // 로딩 중 인디케이터
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                )
                    : Text('등록하기'), // 기본 텍스트
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15), // 버튼 높이 조절
                    minimumSize: Size(double.infinity, 36) // 버튼 너비 최대
                ),
              ),
            ], // end children (ListView)
          ), // end Form
        ), // end Padding
      ), // end body
    ); // end Scaffold
  } // end build
} // end _AddSupplyScreenState