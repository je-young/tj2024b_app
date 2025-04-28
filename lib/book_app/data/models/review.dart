// lib/data/models/review.dart : Review 클래스 정의
// 리뷰 데이터를 담을 Dart 모델 클래스



class Review {
  final int id;
  final String content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.content,
    required this.createdAt,
  });

// JSON 데이터를 Review 객체로 변환하는 팩토리 생성자
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    content: json["content"],
    createdAt: DateTime.parse(json["createdAt"]),
  );
} // end Review