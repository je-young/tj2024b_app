// lib/example/day04/_비품CRUD/home.dart
// 메인 화면 (비품 목록 표시, 페이징, 삭제, 이동 버튼)

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// API 기본 URL (필요시 별도 파일로 분리 권장)
const String API_BASE_URL = 'http://localhost:8080/api/supplies'; // ✅ dio를 이용한 웹브라우저 IP 주소
//const String API_BASE_URL = 'http://10.0.2.2:8080/api/supplies'; // ✅ 에뮬레이터 안에서 접근 가능한 로컬 호스트 IP : 10.0.2.2
//const String API_BASE_URL = 'https://accurate-keriann-jey2965-01e9656d.koyeb.app/api/supplies'; // ✅ 배포후 IP 주소



// 상태가 있는 위젯 선언
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// State 클래스
class _HomeScreenState extends State<HomeScreen> {
  final Dio dio = Dio(); // Dio 인스턴스 생성
  List<dynamic> supplies = []; // 비품 목록을 저장할 리스트 (상태 변수)
  int currentPage = 1; // 현재 페이지 번호 (1부터 시작)
  int totalPages = 1;  // 전체 페이지 수
  bool isLoading = true; // 데이터 로딩 상태
  final int pageSize = 5; // 페이지 당 항목 수

  // 위젯 초기화 시 실행 (최초 1회)
  @override
  void initState() {
    super.initState();
    fetchSuppliesPage(currentPage); // 초기 데이터 로드
  }

  // 페이징된 비품 목록 조회 함수 (비동기)
  Future<void> fetchSuppliesPage(int page) async {
    if (!mounted) return; // 위젯이 화면에 없으면 중단
    setState(() { isLoading = true; }); // 로딩 상태 시작
    try {
      // 서버에 GET 요청 (페이징 파라미터 포함)
      final response = await dio.get(
        '$API_BASE_URL/page',
        queryParameters: {'page': page, 'size': pageSize},
      );
      // 응답 성공 시 데이터 처리
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> pageData = response.data;
        if (!mounted) return;
        // setState 호출하여 상태 업데이트 및 화면 갱신 요청
        setState(() {
          supplies = pageData['content'] ?? []; // 실제 데이터 목록 업데이트
          totalPages = pageData['totalPages'] ?? 1; // 전체 페이지 수 업데이트
          currentPage = page; // 현재 페이지 번호 업데이트
          isLoading = false; // 로딩 상태 완료
        });
      } else {
        // 서버에서 에러 응답 시
        throw Exception('Failed to load supplies page (status: ${response.statusCode})');
      }
    } catch (e) { // 네트워크 오류 등 예외 발생 시
      print('페이징 조회 에러: $e');
      if (!mounted) return;
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('목록 로딩 실패: $e')));
    }
  }

  // 비품 삭제 함수 (비동기)
  Future<void> deleteSupply(int id) async {
    // 삭제 확인 다이얼로그
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('ID $id 비품을 정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('삭제')),
        ],
      ),
    );

    if (confirm != true) return; // 사용자가 '취소' 선택 시 중단

    try {
      // 서버에 DELETE 요청 (PathVariable로 id 전달)
      final response = await dio.delete('$API_BASE_URL/$id');

      // 성공 응답(204 No Content) 처리
      if (response.statusCode == 204) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID $id 비품 삭제 성공')));
        // 삭제 후 현재 페이지 다시 로드
        fetchSuppliesPage(currentPage);
      } else {
        throw Exception('Failed to delete supply (status: ${response.statusCode})');
      }
    } catch (e) {
      print('삭제 에러: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
    }
  }

  // 목록 새로고침 함수 (Pull-to-Refresh 용)
  Future<void> _refreshSupplies() async {
    await fetchSuppliesPage(1); // 첫 페이지로 새로고침
  }

  // UI 구성 (build 메소드)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱 바
      appBar: AppBar(
        title: Text('비품 목록 (페이지 $currentPage/$totalPages)'), // 현재 페이지 정보 표시
        actions: [ // 앱 바 오른쪽 액션 버튼
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: () => fetchSuppliesPage(currentPage), // 현재 페이지 다시 로드
          )
        ],
      ),
      // 플로팅 액션 버튼 (비품 추가 화면으로 이동)
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: '비품 추가',
        onPressed: () async {
          // '/add' 경로로 이동, 반환 값은 사용하지 않지만 await 가능
          await Navigator.pushNamed(context, "/add");
          // 등록 화면에서 돌아온 후 목록 새로고침
          _refreshSupplies();
        },
      ),
      // 화면 본문
      body: isLoading // 로딩 중 표시
          ? Center(child: CircularProgressIndicator())
          : Column( // 세로 배치
        children: [
          // 비품 목록 영역 (스크롤 가능)
          Expanded(
            child: RefreshIndicator( // 아래로 당겨 새로고침
              onRefresh: _refreshSupplies,
              child: supplies.isEmpty // 목록이 비었을 때
                  ? Center(child: Text('등록된 비품이 없습니다.\n아래로 당겨 새로고침하세요.'))
                  : ListView.builder( // 목록이 있을 때
                itemCount: supplies.length, // 목록 아이템 개수
                itemBuilder: (context, index) { // 각 아이템을 빌드
                  final supply = supplies[index];
                  final int supplyId = (supply['id'] as num?)?.toInt() ?? 0; // ID 타입 변환

                  return Card( // 카드 형태로 감싸기
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile( // 목록 아이템 위젯
                      leading: CircleAvatar(child: Text('$supplyId')), // 왼쪽에 ID 표시
                      title: Text(supply['name'] ?? '이름 없음'), // 제목
                      subtitle: Text('수량: ${supply['quantity'] ?? 0}'), // 부제목 (수량)
                      trailing: Row( // 오른쪽에 아이콘 버튼들 배치
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton( // 수정 버튼
                            icon: Icon(Icons.edit, color: Colors.blue),
                            tooltip: '수정',
                            onPressed: () async {
                              // '/update' 경로로 이동하며 ID 전달
                              await Navigator.pushNamed(context, "/update", arguments: supplyId);
                              _refreshSupplies(); // 수정 후 돌아오면 새로고침
                            },
                          ),
                          IconButton( // 상세 보기 버튼
                            icon: Icon(Icons.visibility, color: Colors.grey),
                            tooltip: '상세보기',
                            onPressed: () {
                              // '/detail' 경로로 이동하며 ID 전달
                              Navigator.pushNamed(context, "/detail", arguments: supplyId);
                            },
                          ),
                          IconButton( // 삭제 버튼
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: '삭제',
                            onPressed: () => deleteSupply(supplyId), // 삭제 함수 호출
                          ),
                        ],
                      ),
                      onTap: () { // ListTile 자체 클릭 시 상세 보기
                        Navigator.pushNamed(context, "/detail", arguments: supplyId);
                      },
                    ), // end ListTile
                  ); // end Card
                },
              ), // end ListView.builder
            ), // end RefreshIndicator
          ), // end Expanded

          // 페이징 컨트롤 영역
          if (!isLoading && totalPages > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton( // 이전 페이지 버튼
                    icon: Icon(Icons.chevron_left),
                    // 현재 페이지가 1보다 클 때만 활성화
                    onPressed: currentPage > 1 ? () => fetchSuppliesPage(currentPage - 1) : null,
                  ),
                  Text('페이지 $currentPage / $totalPages'), // 현재/전체 페이지
                  IconButton( // 다음 페이지 버튼
                    icon: Icon(Icons.chevron_right),
                    // 현재 페이지가 마지막 페이지보다 작을 때만 활성화
                    onPressed: currentPage < totalPages ? () => fetchSuppliesPage(currentPage + 1) : null,
                  ),
                ],
              ),
            ),
        ],
      ), // end Column
    ); // end Scaffold
  } // end build
} // end _HomeScreenState