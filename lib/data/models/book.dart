// lib/data/models/book.dart : Book 클래스 정의
// dio는 JSON 파싱을 자동으로 해주지만, 최종적으로 Dart 객체로 변환하는 로직은 모델 클래스에 있는 것이 좋음.

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
  factory Book.fromJson(Map<String, dynamic> json) => Book(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      description: json["description"],
      // DateTime.parse()를 사용하여 JSON 문자열을 DateTime 객체로 변환
      createdAt: DateTime.parse(json["createdAt"] as String)
  ); // end Book.fromJson

} // end Book