// lib/data/services/api_service.dart : API 연동을 위한 Dart 클래스


import 'package:dio/dio.dart';       // [1] dio 패키지 import
import '../models/book.dart';     // [2] Book 모델 import


class ApiService {
  // [3] Dio 인스턴스 생성 및 기본 설정
  final Dio _dio = Dio(BaseOptions(
    // [3-1] 백엔드 API 기본 URL 정의 (★ 중요: 환경에 맞게 수정)
    baseUrl: 'http://localhost:8080/api', // Web 브라우저
    // baseUrl: 'http://10.0.2.2:8080/api', // Android 에뮬레이터
    // baseUrl: 'http://localhost:8080/api', // iOS 시뮬레이터 또는 웹
    connectTimeout: const Duration(seconds: 5), // 연결 타임아웃 5초
    receiveTimeout: const Duration(seconds: 3), // 응답 타임아웃 3초
  ));

  // [4] 책 목록 조회 API 호출 메소드 정의
  Future<List<Book>> getBooks() async {
    try {
      // [4-1] dio.get()을 사용하여 API 호출 (경로는 baseUrl 뒤에 붙음)
      final response = await _dio.get('/books');

      // [4-2] 응답 상태 코드 확인 (dio는 2xx 외에는 에러로 처리하는 경향이 있음)
      if (response.statusCode == 200) {
        // [4-3] 성공 시: response.data는 dio가 자동으로 List<dynamic> (JSON 배열) 또는 Map<String, dynamic> (JSON 객체)으로 파싱해 줌
        // 여기서는 책 목록이므로 List<dynamic>으로 예상됨
        if (response.data is List) {
          // [4-4] List<dynamic>을 List<Book>으로 변환
          // 각 Map 아이템을 Book.fromJson을 이용해 Book 객체로 만들고 리스트로 반환
          List<Book> books = (response.data as List)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
          return books;
        } else {
          // [4-5] 예상치 못한 데이터 타입인 경우 에러 처리
          throw Exception('서버에서 수신 한 잘못된 데이터 형식');
        } // end if
      } else {
        // [4-6] 200 외의 성공 코드는 여기서 처리하지 않음 (보통 dio가 에러로 던짐)
        // 필요하다면 여기서 추가 상태 코드 처리 가능
        throw Exception('책을로드하지 못했습니다. (상태 코드 : ${response.statusCode})');
      } // end if
    } on DioException catch (e) { // [5] Dio 관련 에러 처리 (네트워크, 타임아웃, 상태 코드 에러 등)
      String errorMessage = '책을 로드하지 못했습니다 : ';
      if (e.response != null) {
        // [5-1] 서버 응답이 있는 경우 (4xx, 5xx 등)
        print('오류 응답 데이터 : ${e.response?.data}');
        print('오류 응답 헤더 : ${e.response?.headers}');
        errorMessage += '서버 오류 ${e.response?.statusCode}';
      } else {
        // [5-2] 서버 응답 없이 에러 발생 (네트워크 연결 문제, 타임아웃 등)
        print('오류 전송 요청 : ${e.message}');
        errorMessage += e.message ?? '알 수없는 DIO 오류';
      } // end if
      throw Exception(errorMessage);
    } catch (e) { // [6] Dio 외의 다른 예외 처리
      print('예상치 못한 오류 : $e');
      throw Exception('예상치 못한 오류가 발생했습니다. $e');
    } // end try
  } // end getBooks
} // end ApiService