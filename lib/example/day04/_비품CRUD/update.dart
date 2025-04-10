// lib/example/day04/_비품CRUD/update.dart
// 비품 정보 수정 화면

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import '../constants/api_constants.dart'; // API 상수 import 또는 직접 사용

// API 기본 URL (필요시 별도 파일로 분리 권장)
const String API_BASE_URL = 'http://localhost:8080/api/supplies'; // ✅ dio를 이용한 웹브라우저 IP 주소
//const String API_BASE_URL = 'http://10.0.2.2:8080/api/supplies'; // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
//const String API_BASE_URL = 'https://accurate-keriann-jey2965-01e9656d.koyeb.app/api/supplies'; // ✅ 배포후 IP 주소

// 상태가 있는 위젯
class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  // Form 상태 관리 키
  final _formKey = GlobalKey<FormState>();
  // 입력 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final Dio dio = Dio(); // Dio 인스턴스
  int? supplyId; // 수정할 비품의 ID (이전 화면에서 받음)
  bool isLoading = true; // 초기 데이터 로딩 상태
  bool _isSaving = false; // 수정 요청 진행 중 상태
  String errorMessage = ''; // 에러 메시지

  // didChangeDependencies: ModalRoute 사용 위해 이 생명주기 사용
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 한번만 실행되도록 체크
    if (supplyId == null) {
      // arguments 가져오기
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is int) {
        supplyId = arguments; // ID 저장
        print('Update 화면: 전달받은 ID = $supplyId');
        fetchSupplyById(supplyId!); // 기존 데이터 로드 함수 호출
      } else {
        // 잘못된 ID 처리
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = '수정할 비품 ID가 올바르지 않습니다.';
          });
        }
      }
    }
  }

  // 기존 비품 데이터 조회 함수 (비동기)
  Future<void> fetchSupplyById(int id) async {
    if (!mounted) return;
    setState(() { isLoading = true; errorMessage = ''; });
    try {
      // 서버에 GET 요청
      final response = await dio.get('$API_BASE_URL/$id');
      // 성공 응답 처리
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        if (!mounted) return;
        // setState 내에서 컨트롤러 값 설정 ✨
        setState(() {
          _nameController.text = data['name'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _quantityController.text = data['quantity']?.toString() ?? '';
          isLoading = false; // 로딩 완료
        });
      } else {
        throw Exception('Failed to load supply details for update (status: ${response.statusCode})');
      }
    } catch (e) { // 예외 처리
      print('수정 데이터 로드 에러: $e');
      if (!mounted) return;
      setState(() { isLoading = false; errorMessage = '데이터 로딩 실패: $e'; });
    }
  }

  // 비품 수정 요청 함수 (비동기)
  Future<void> _updateSupply() async {
    // Form 유효성 검사 및 ID 존재 확인
    if (_formKey.currentState!.validate() && supplyId != null) {
      setState(() { _isSaving = true; }); // 저장 중 상태 시작
      try {
        // 서버에 보낼 수정된 데이터 Map 생성
        final data = {
          // 'id': supplyId, // PUT 요청 시 ID는 보통 URL 경로로 전달됨 (서버 구현 확인)
          'name': _nameController.text,
          'description': _descriptionController.text,
          'quantity': int.tryParse(_quantityController.text) ?? 0,
        };
        // Dio PUT 요청 (URL 경로에 ID 포함)
        final response = await dio.put('$API_BASE_URL/$supplyId', data: data);

        // 성공 응답(200 OK) 처리
        if (response.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비품 수정 성공!')));
          Navigator.pop(context); // 수정 성공 후 이전 화면(Home 또는 Detail)으로 돌아가기
        } else {
          // 서버에서 다른 상태 코드 응답 시
          throw Exception('Failed to update supply (status: ${response.statusCode})');
        }
      } catch (e) { // 예외 처리
        print('수정 에러: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('수정 실패: $e')));
      } finally { // 항상 실행
        if (!mounted) return;
        setState(() { _isSaving = false; }); // 저장 중 상태 해제
      }
    } // end if (validate)
  } // end _updateSupply

  // 컨트롤러 리소스 해제
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // UI 구성 (build 메소드)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비품 수정 (ID: $supplyId)')), // 상단 앱 바
      body: isLoading // 초기 데이터 로딩 중
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty // 에러 발생 시
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
          : Padding( // 데이터 로딩 완료 시 수정 폼 표시
        padding: const EdgeInsets.all(16.0),
        child: Form( // Form 위젯
          key: _formKey, // 키 연결
          child: ListView( // 스크롤 가능한 폼
            children: [
              // 비품명 입력 필드 (초기값 로드됨)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '비품명 *', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? '비품명을 입력하세요.' : null,
              ),
              SizedBox(height: 16),

              // 비품 설명 입력 필드 (초기값 로드됨)
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: '비품 설명', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // 수량 입력 필드 (초기값 로드됨)
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: '수량 *', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return '수량을 입력하세요.';
                  if (int.tryParse(value) == null || int.parse(value) < 0) return '0 이상의 유효한 숫자를 입력하세요.';
                  return null;
                },
              ),
              SizedBox(height: 30),

              // 수정 완료 버튼
              ElevatedButton(
                // 저장 중이면 비활성화
                onPressed: _isSaving ? null : _updateSupply,
                child: _isSaving // 저장 중 상태에 따라 다른 위젯 표시
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('수정 완료'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 36)
                ),
              ),
            ], // end children (ListView)
          ), // end Form
        ), // end Padding
      ), // end body
    ); // end Scaffold
  } // end build
} // end _UpdateScreenState