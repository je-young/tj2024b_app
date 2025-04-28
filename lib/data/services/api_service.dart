// lib/data/services/api_service.dart : API 연동을 위한 Dart 클래스

import 'package:dio/dio.dart'; // [10] HTTP 통신을 위한 라이브러리
import 'package:flutter_study/data/models/book.dart'; // [2] Book 모델 import
import 'package:flutter_study/data/models/review.dart'; // [6] Review 모델 import

class ApiService {
  // [3] Dio 인스턴스 생성 및 기본 설정
  final Dio _dio = Dio(
    BaseOptions(
      // [3-1] 백엔드 API 기본 URL 정의 (★ 중요: 환경에 맞게 수정)
      baseUrl: 'http://localhost:8080/api', // Web 브라우저
      // baseUrl: 'http://10.0.2.2:8080/api', // Android 에뮬레이터
      // baseUrl: 'http://localhost:8080/api', // iOS 시뮬레이터 또는 웹
      connectTimeout: const Duration(seconds: 5), // 연결 타임아웃 5초
      receiveTimeout: const Duration(seconds: 3), // 응답 타임아웃 3초
    ),
  );

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
          List<Book> books =
              (response.data as List)
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
    } on DioException catch (e) {
      // [5] Dio 관련 에러 처리 (네트워크, 타임아웃, 상태 코드 에러 등)
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
    } catch (e) {
      // [6] Dio 외의 다른 예외 처리
      print('예상치 못한 오류 : $e');
      throw Exception('예상치 못한 오류가 발생했습니다. $e');
    } // end try
  } // end getBooks

  // [6-1] 책 상세 정보 조회 API 호출 메소드 정의
  Future<Book> getBookById(int id) async {
    try {
      // [6-2] dio.get()을 사용하여 특정 책 ID로 API 호출
      final response = await _dio.get('/books/$id'); // 경로 변수 사용

      if (response.statusCode == 200) {
        // [6-3] 성공 시: response.data는 Map<String, dynamic> 형태로 예상됨
        if (response.data is Map<String, dynamic>) {
          // [6-4] Map 데이터를 Book.fromJson을 이용해 Book 객체로 변환
          return Book.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('책 세부 사항에 대해 잘못된 데이터 형식');
        }
      } else {
        throw Exception(
          '도서 세부 사항을 로드하지 못했습니다 (상태 코드 : ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      // [6-5] Dio 관련 예외 처리
      String errorMessage = '책 세부 사항을로드하지 못했습니다 (ID: $id): ';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'Book with ID $id 찾을 수 없습니다.';
        } else {
          errorMessage += '서버 오류 ${e.response?.statusCode}';
        }
      } else {
        errorMessage += e.message ?? '알 수없는 DIO 오류';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // [6-6] 기타 에레 처리
      throw Exception('책을 가져 오는 동안 예기치 않은 오류가 발생했습니다. $id: $e');
    } // end try catch
  } // end getBookById

  // [7] 특정 책의 리뷰 목록 조회 API 호출 메소드
  Future<List<Review>> getReviewsByBookId(int bookId) async {
    try {
      // [7-1] dio.get()을 사용하여 특정 책의 ID의 리뷰 목록 API 호출
      final response = await _dio.get('/books/$bookId/reviews');

      if (response.statusCode == 200) {
        // [7-2] 성공 시: response.data는 List<dynamic> 형태로 예상됨
        if (response.data is List) {
          // [7-3] List<dynamic>을 List<Review>로 변환
          List<Review> reviews =
              (response.data as List)
                  .map((item) => Review.fromJson(item as Map<String, dynamic>))
                  .toList();
          return reviews;
        } else {
          // [7-4] 책은 존재하지만 리뷰 형식이 잘못된 경우 (가능성은 낮음)
          throw Exception('리뷰를 위해 수신 된 잘못된 데이터 형식');
        }
      } else {
        // 404 (책 없음) 에러는 getBookById 에서 먼저 처리될 가능성이 높음
        throw Exception('리뷰를 로드하지 못했습니다 (상태 코드 : ${response.statusCode})');
      } // end if
    } on DioException catch (e) {
      // [7-5] Dio 관련 예외 처리 (주로 책 ID 자체가 없는 경우에 대한 처리는 getBookById에서 될 것임)
      String errorMessage = 'Book ID에 대한 리뷰를 로드하지 못했습니다 $bookId: ';
      if (e.response != null) {
        errorMessage += '서버 오류 ${e.response?.statusCode}';
      } else {
        errorMessage += e.message ?? '알 수없는 DIO 오류';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // [7-6] 기타 예외 처리
      throw Exception('책에 대한 리뷰를 가져 오는 동안 예기치 않은 오류가 발생했습니다 $bookId: $e');
    } // end try catch
  } // end getReviewsByBookId

  // [8] 책 등록 API 호출 메소드
  Future<Book> createBook({
    required String title,
    required String author,
    required String description,
    required String password,
  }) async {
    try {
      // [8-1] 요청 본문 데이터 (Map) 생성
      final Map<String, dynamic> data = {
        'title': title,
        'author': author,
        'description': description,
        'password': password,
      }; // end Map

      // [8-2] dio.post() 사용하여 API 호출 (경로, 데이터 전달)
      // dio 는 기본적으로 Map 데이터를 JSON 문자열로 변환하여 전송함
      final response = await _dio.post('/books', data: data);

      // [8-3] 응답 상태 코드 확인 (보통 201 Created)
      if (response.statusCode == 201) {
        // [8-4] 성공 시: 응답 본문(생성된 Book 정보)을 Map 으로 파싱
        if (response.data is Map<String, dynamic>) {
          // [8-5] Map 데이터를 Book.fromJson 으로 Book 객체 변환 후 반환
          return Book.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('Invalid data format received after creating book');
        }
      } else {
        // 201 외의 성공 코드는 거의 없음
        throw Exception(
          'Failed to create book (status code: ${response.statusCode})',
        );
      } // end if
    } on DioException catch (e) {
      // [8-6] Dio 관련 에러 처리 (400 Bad Request 등)
      String errorMessage = 'Failed to create book: ';
      if (e.response != null) {
        // 서버에서 보낸 에러 메시지가 있다면 포함 (예: 유효성 검사 실패)
        errorMessage +=
            e.response?.data?['message'] ??
            'Server error ${e.response?.statusCode}';
        print('Error response data: ${e.response?.data}');
      } else {
        errorMessage += e.message ?? 'Unknown Dio error';
      } // end if
      throw Exception(errorMessage);
    } catch (e) {
      // [8-7] 기타 에러 처리
      throw Exception('An unexpected error occurred while creating book: $e');
    } // end try catch
  } // end createBook

  // [9] 리뷰 등록 API 호출 메소드
  Future<Review> createReview({
    required int bookId, // [9-1] 리뷰를 등록할 책의 ID
    required String content, // [9-2] 리뷰 내용
    required String password, // [9-3] 리뷰 삭제용 비밀번호
  }) async {
    try {
      // [9-4] 요청 본문 데이터 생성
      final Map<String, dynamic> data = {
        'content': content,
        'password': password,
      }; // end Map

      // [9-5] dio.post() 사용하여 API 호출 (경로에 bookId 포함)
      final response = await _dio.post('/books/$bookId/reviews', data: data);

      // [9-6] 응답 상태 코드 확인 (201 Created)
      if (response.statusCode == 201) {
        // [9-7] 성공 시: 응답 본문을 Review 객체로 변환 후 반환
        if (response.data is Map<String, dynamic>) {
          return Review.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('리뷰 생성에 대해 잘못된 데이터 형식');
        } // end if
      } else {
        throw Exception('리뷰 작성 실패 (status code: ${response.statusCode})');
      } // end if
    } on DioException catch (e) {
      // [9-8] Dio 관련 에러 처리 (책 ID 없음 404, 입력값 오류 400 등)
      String errorMessage = '리뷰 작성 실패: ';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          errorMessage = '리뷰를 작성할 수 없습니다.: Book with ID $bookId 찾을 수 없음.';
        } else {
          errorMessage +=
              e.response?.data?['message'] ?? '서버 에러 ${e.response?.statusCode}';
        } // end if
        print('에러 응답 데이터: ${e.response?.data}');
      } else {
        errorMessage += e.message ?? '알 수 없는 Dio 오류';
      } // end if
      throw Exception(errorMessage);
    } catch (e) {
      // [9-9] 기타 에러 처리
      throw Exception('리뷰를 만드는 동안 예기치 않은 오류가 발생했습니다.: $e');
    } // end try catch
  } // end async createReview

  // [10-1] 리뷰 삭제 API 호출 메소드
  Future<void> deleteReview({
    required int reviewId, // 삭제할 리뷰 ID
    required String password, // 검증용 비밀번호
  }) async {
    try {
      // [10-2] dio.delete() 사용하여 API 호출 (Query Parameter 로 비밀번호 전달)
      await _dio.delete(
        '/reviews/$reviewId', // 경로에 reviewId 포함
        queryParameters: {'password': password}, // queryParameters 로 전달
      );
      // [10-3] 성공 시 (보통 204 No Content) 별도 반환값 없음
    } on DioException catch (e) {
      // [10-4] Dio 관련 에러 처리 (리뷰 없음 404, 비밀번호 틀림 400 등)
      String errorMessage = '리뷰를 삭제하지 못했습니다.: ';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'ID가 $reviewId인 리뷰를 찾을 수 없습니다.';
        } else if (e.response?.statusCode == 400) {
          // 백엔드에서 비밀번호 틀릴 시 400 가정
          errorMessage = e.response?.data?['message'] ?? '비밀번호가 올바르지 않습니다.';
        } else {
          errorMessage += '서버 에러 ${e.response?.statusCode}';
        } // end if else
        print('에러 응답 데이터: ${e.response?.data}');
      } else {
        errorMessage += e.message ?? '알 수 없는 Dio 오류';
      } // end if else
      throw Exception(errorMessage);
    } catch (e) {
      // [10-5] 기타 에러 처리
      throw Exception('리뷰를 삭제하는 동안 예기치 않은 오류가 발생했습니다.: $e');
    } // end try catch
  } // end async deleteReview

  // [11] 책 삭제 API 호출 메소드
  Future<void> deleteBook({
    required int bookId, // 삭제할 책 ID
    required String password, // 검증용 비밀번호
  }) async {
    try {
      // [11-2] dio.delete() 사용하여 API 호출 (Query Parameter 로 비밀번호 전달)
      await _dio.delete(
        '/books/$bookId', // 경로에 bookId 포함
        queryParameters: {'password': password}, // queryParameters 로 전달
      );
      // [11-3] 성공 시 (204 No Content) 별도 반환값 없음
    } on DioException catch (e) {
      // [11-4] Dio 관련 에러 처리 (책 없음 404, 비밀번호 틀림 400 등)
      String errorMessage = '책을 삭제하지 못했습니다.: ';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'ID가 $bookId인 책을 찾을 수 없습니다.';
        } else if (e.response?.statusCode == 400) {
          errorMessage = e.response?.data?['message'] ?? '비밀번호가 올바르지 않습니다.';
        } else {
          errorMessage += '서버 에러 ${e.response?.statusCode}';
        } // end else
        print('에러 응답 데이터: ${e.response?.data}');
      } else {
        errorMessage += e.message ?? '알 수 없는 Dio 오류';
      } // end if else
      throw Exception(errorMessage);
    } catch (e) {
      // [11-5] 기타 에러 처리
      throw Exception('책을 삭제하는 동안 예기치 않은 오류가 발생했습니다.: $e');
    } // end try catch
  } // end async deleteBook

  // [12] 책 수정 API 호출 메소드
  Future<Book> updateBook({
    required int bookId,        // [1-1] 수정할 책 ID
    required String title,       // [1-2] 수정할 제목
    required String author,      // [1-3] 수정할 저자
    required String description, // [1-4] 수정할 설명
    required String password,    // [1-5] 검증용 비밀번호
  }) async {
    try {
      // [12-2] 요청 본문 데이터 생성
      final Map<String, dynamic> data = {
        'title': title,
        'author': author,
        'description': description,
        'password': password, // 비밀번호는 body 에 포함하여 전송 (백엔드 구현에 따름)
      };

      // [12-3] dio.put() 사용하여 API 호출
      final response = await _dio.put('/books/$bookId', data: data);

      // [12-4] 응답 상태 코드 확인 (보통 200 OK)
      if (response.statusCode == 200) {
        // [12-5] 성공 시: 응답 본문(수정된 Book 정보)을 Book 객체로 변환 후 반환
        if (response.data is Map<String, dynamic>) {
          return Book.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('Invalid data format received after updating book');
        }
      } else {
        throw Exception('Failed to update book (status code: ${response.statusCode})');
      }
    } on DioException catch (e) {
      // [12-6] Dio 관련 에러 처리 (책 없음 404, 비밀번호 틀림/입력 오류 400 등)
      String errorMessage = 'Failed to update book: ';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'Book with ID $bookId not found.';
        } else if (e.response?.statusCode == 400) {
          errorMessage = e.response?.data?['message'] ?? 'Incorrect password or invalid data.';
        } else {
          errorMessage += 'Server error ${e.response?.statusCode}';
        }
        print('Error response data: ${e.response?.data}');
      } else {
        errorMessage += e.message ?? 'Unknown Dio error';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // [12-7] 기타 에러 처리
      throw Exception('An unexpected error occurred while updating book: $e');
    }
  } // end async updateBook

} // end ApiService
