// 조건문
void main(){
  int number = 31;
  if(number % 2 == 1){
    print('홀수!');
  }else{
    print('짝수!');
  }
  // 홀수! 출력

  String light = "red";
  if(light == "green"){
    print("초록불!");
  }else if(light == "yellow"){
    print("노란불!");
  }else if(light == "red"){
    print("빨간불!");
  }else{
    print("잘못된 신호입니다.");
  }
  // 빨간불! 출력

  String light2 = "purple";
  if(light2 == "green"){
    print("초록불!");
  }else if(light2 == "yellow"){
    print("노란불!");
  }else if(light2 == "red"){
    print("빨간불!");
  }
  // 해당사항 없으므로 출력안됨.

  for(int i = 0 ; i < 100 ; i++){
    print(i); // 1 ~ 99 까지 출력
  }

  List<String> subjects = ["자료구조", "이산수학", "알고리즘", "플러터"];
  for(String subject in subjects){
    print(subject); // 자료구조, 이산수학, 알고리즘, 플러터 출력
  }

  int i = 0;
  while(i < 100){
    print(i+1); // 1 ~ 100 까지 출력
    i = i + 1; // 1씩 증가
  }

  // i = 0;
  // while(true){
  //   print(i+1); // 무한루프
  //   i = i + 1; // 1씩 증가
  // }

  i = 0;
  while(true){
    print(i+1); // 무한루프
    i = i + 1; // 1씩 증가
    if(i == 100){
      break; // 100이 되면 반복문 종료
    }
  }

  for(int i = 0 ; i < 100; i++ ){ //
    if(i % 2 == 0){
      continue; // 짝수이면 다음 반복으로 넘어감
    }
    print(i+1); // 홀수에 1을 더한 값 출력
  }

  int number3 = add(1 , 2);
  print(number3); // 3 출력

  int number4 = 1;
  switch(number4) {
    case 1:
      print('one');
  }

  const a = 'a';
  const b = 'b';
  List<String> obj = [a , b];
  switch(obj){
    case [a , b]:
      print('$a , $b');
  }

  switch(obj){
    // 1 == obj 인 경우 일치합니다
    case 1:
      print('one');

    // OBJ의 값이 'First'와 'last'의 상수 값 사이에있는 경우 일치
    // case >= first && <= last:
    //   print('in range');
    // 일치 OBJ가 두 필드가있는 레코드 인 경우 일치하는 다음 필드를 'a'및 'b'에 할당합니다.
    case (var a , var b):
      print('a = $a , b = $b');

    default:
  }

} // end main

int add(int a, int b){
  return a + b;
}