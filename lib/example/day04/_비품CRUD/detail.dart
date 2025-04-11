// lib/example/day04/_비품CRUD/detail.dart
// 비품 상세 정보 화면

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import '../constants/api_constants.dart'; // API 상수 import 또는 직접 사용

// API 기본 URL (필요시 별도 파일로 분리 권장)
//const String API_BASE_URL = 'http://localhost:8080/api/supplies'; // ✅ dio를 이용한 웹브라우저 IP 주소
//const String API_BASE_URL = 'http://10.0.2.2:8080/api/supplies'; // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
const String API_BASE_URL = 'https://accurate-keriann-jey2965-01e9656d.koyeb.app/api/supplies'; // ✅ 배포후 IP 주소

// 상태가 있는 위젯
class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Dio dio = Dio();
  Map<String, dynamic>? supply; // 상세 정보를 저장할 Map (null 가능)
  bool isLoading = true; // 데이터 로딩 상태
  String errorMessage = ''; // 에러 메시지
  int? supplyId; // 이전 화면에서 전달받을 ID

  // didChangeDependencies: 위젯의 의존성이 변경될 때 호출 (ModalRoute 사용 시점)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 한번만 실행되도록 체크 (supplyId가 null일 때만)
    if (supplyId == null) {
      // ModalRoute를 통해 arguments 가져오기
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is int) { // 타입 검사
        supplyId = arguments; // ID 저장
        print('Detail 화면: 전달받은 ID = $supplyId');
        fetchSupplyById(supplyId!); // 상세 정보 요청 함수 호출
      } else {
        // 잘못된 ID 처리
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = '잘못된 비품 ID가 전달되었습니다.';
          });
        }
      }
    }
  }

  // ID로 비품 상세 정보 조회 함수 (비동기)
  Future<void> fetchSupplyById(int id) async {
    if (!mounted) return;
    setState(() { isLoading = true; errorMessage = ''; }); // 로딩 시작
    try {
      // 서버에 GET 요청 (PathVariable로 id 전달)
      final response = await dio.get('$API_BASE_URL/$id');
      // 성공 응답 처리
      if (response.statusCode == 200 && response.data != null) {
        if (!mounted) return;
        setState(() {
          // 응답 데이터를 Map으로 변환하여 상태 변수에 저장
          supply = Map<String, dynamic>.from(response.data);
          isLoading = false; // 로딩 완료
        });
      } else {
        throw Exception('Failed to load supply details (status: ${response.statusCode})');
      }
    } catch (e) { // 예외 처리
      print('상세 조회 에러: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = '데이터 로딩 실패: $e';
      });
    }
  }

  // 날짜/시간 문자열 포맷 함수 (yyyy-MM-dd HH:mm 형식)
  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString; // 파싱 실패 시 원본 반환
    }
  }

  // UI 구성 (build 메소드)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱 바 (로딩 상태 및 비품명 표시)
      appBar: AppBar(
        title: Text(isLoading ? '로딩 중...' : (supply?['name'] ?? '상세 정보')),
      ),
      // 화면 본문
      body: isLoading // 로딩 중일 때
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty // 에러 발생 시
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
          : supply != null // 데이터 로딩 성공 시
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        // 내용이 길어질 수 있으므로 ListView 사용
        child: ListView(
          children: [
            // 각 정보 항목을 표시하는 헬퍼 위젯 사용
            _buildDetailItem('ID', supply!['id']?.toString() ?? 'N/A'),
            _buildDetailItem('비품명', supply!['name'] ?? 'N/A'),
            _buildDetailItem('설명', supply!['description'] ?? '내용 없음'),
            _buildDetailItem('수량', supply!['quantity']?.toString() ?? '0'),
            _buildDetailItem('등록일', _formatDate(supply!['createdDate'])),
            _buildDetailItem('최근 수정일', _formatDate(supply!['modifiedDate'])),
            SizedBox(height: 30),
            // 수정 화면으로 이동하는 버튼
            ElevatedButton.icon(
              icon: Icon(Icons.edit_note),
              label: Text('이 비품 수정하기'),
              onPressed: () async {
                // '/update' 경로로 이동하며 ID 전달
                await Navigator.pushNamed(context, "/update", arguments: supply!['id']);
                // 수정 후 돌아왔을 때 상세 정보 다시 로드
                if (supplyId != null && mounted) {
                  fetchSupplyById(supplyId!);
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40)
              ),
            ),
          ],
        ),
      )
          : Center(child: Text('해당 비품 정보를 찾을 수 없습니다.')), // 데이터가 null일 때
    );
  }

  // 상세 정보 항목 표시를 위한 헬퍼 위젯
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column( // 라벨과 값을 세로로 배치하여 가독성 향상
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18)),
          Divider(height: 16), // 항목 간 구분선
        ],
      ),
    );
  }
}