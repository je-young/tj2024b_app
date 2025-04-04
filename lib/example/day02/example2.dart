// Dart 언어는 단일 스레드 기반

// 1. Dio 객체 생성, java : new 클래스명() vs dart : 클래스명()
// 2. 파일 상단에 import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
final dio = Dio(); // final : 상수키워드

void main(){ // main 함수가 스레드를 갖고 코드 시작점.
  print('Dart Start');
  getHttp(); // 해당 함수 호출
  postHttp(); // 해당 함수 호출

} // end main

// 3. (1) 비동기 통신
// dio.HTTP메소드명("URL") vs axios.HTTP메소드명("URL")
// 테스트 : day98 에서 과제3의 TaskController 에게 통신
void getHttp() async {
  // (1) dio 통신 이용한 자바와 통신
  final response = await dio.get('http://localhost:8080/api/courses');
  // (2) 응답 확인
  print(response.data);
} // end getHttp()

// 4. dio.get("URL" , data : {body})
void postHttp() async {
  // (1) 보내고자 하는 내용을 JSON(dart map)
  final sendData = { "courseName" : "수학" };
  // (2) dio 통신 이용한 자바와 통신
  final response = await dio.post('http://localhost:8080/api/courses' , data : sendData);
  // (3) 응답 확인
  print(response.data);
}