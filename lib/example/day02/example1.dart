
void main(){
  // [연산자]

  // +
  int a = 2;
  int b = 1;
  print(a + b); // 3

  // 문자열 병합
  String firstName = 'Jeongjoo';
  String lastName = 'Lee';
  String fullName = lastName + ' ' + firstName;
  print(fullName); // Lee Jeongjoo

  // -
  a = 2;
  b = 1;
  print(a - b); // 1

  // -표현식(양수인 경우 음수 , 음수인 경우 양수가 됨)
  a = 2;
  print(-a); // -2

  // *
  a = 6;
  b = 3;
  print(a * b); // 18

  // /
  a = 10;
  b = 4;
  print(a / b); // 2.5

  // ~/ 나눗셈의 목
  a = 10;
  b = 4;
  print(a ~/ b); // 2

  // % 나눗셈의 나머지
  a = 10;
  b = 4;
  print(a % b); // 2

  // ++변수 에 1을 더한 값
  a = 0;
  print(++a); // 1
  print(a); // 1

  // 변수++ 에 1을 더한 값
  a = 0;
  print(a++); // 0
  print(a); // 1

  // --변수 에 1을 뺀 값
  a = 0;
  print(--a); // -1
  print(a); // -1

  // 변수-- 에 1을 뺀 값
  a = 0;
  print(a--); // 0
  print(a); // -1

  // == 두 값이 같으면 true 아니면 false
  a = 2;
  b = 1;
  print(a == b); // false

  // != 두 값이 다르면 true 아니면 false
  a = 2;
  b = 1;
  print(a != b); // true

  // >
  a = 2;
  b = 1;
  print(a > b); // true

  // <
  a = 2;
  b = 1;
  print(a < b); // false

  // >=
  a = 2;
  b = 1;
  print(a >= b); // true

  // <=
  a = 2;
  b = 2;
  print(a <= b); // true

  // =
  a = 1; // 할당
  print(a); // 1
  a = 2; // 재할당

  // +=, -=, *=, /=, ~/=, %=
  a *= 3; // a = a * 3
  print(a);

  // !표현식 결과를 뒤집음
  a = 2;
  b = 1;
  bool result = a > b; // true
  print(!result); // false);

  // || or
  a = 3;
  b = 2;
  int c = 1;
  print(a > b); // true
  print(a < b); // false
  print(a > b || a < c); // true

  // && and
  a = 3;
  b = 2;
  c = 1;
  print(a > b); // true
  print(b < c); // false
  print(a > b && b < c); // false)
}