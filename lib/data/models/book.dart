// lib/data/models/book.dart :
// 백엔드의 BookResponse DTO에 해당하는 Dart 클래스. JSON 데이터를 이 클래스의 객체로 변환하는 fromJson 팩토리 생성자를 포함

import 'dart:convert';

// [3] JSON 배열 문자열 전체를 List<Book> 으로 변환하는 헬퍼 함수 (ApiService 에서 사용하기 위함)

List<Book> booksFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

// [1] Book 클래스 정의 : 백엔드의 BookResponse DTO 필드에 맞춰 속성 정의
class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final DateTime createdAt;

  // [1-1] 생성자 정의
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.createdAt,
  });

  // [2]fromJson 팩토리 생성자 정의 : Map 형태의 JSON 데이터를 Book 클래스의 객체로 변환
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
        createdAt: DateTime.parse(json["createdAt"]) // 날짜 문자열 파싱
    ); // end return
  } // end Book.fromJson
} // end Book