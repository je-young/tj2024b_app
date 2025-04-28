void main(){
  // p.67 레코드 , dart3 부터 추가된 타입
  // 튜플 = 값의 묶음 = 집합
  // 익명 : 레코드에 속한 값들은 꼭 'key' 가질 필요가 없다.  $순서번호

  // 1. *레코드 생성하는 방법1*
  dynamic record = ( 'first' , a : 2 , b : true , 'last' );
  print( record );

  // 2. 레코드 생성하는 방법2 : 명시적 타입
  ( String , int ) record2;
  record2 = ('유재석' , 40 );  print( record2 );

  // 3. 레코드의 값 호출 , *구조 분해 할당 가능*
  print( record.$1 ); // key가 존재하지 않은  첫번째 value
  print( record.a ); // 'a' 라는 key의 값 반환
  print( record.b ); // 'b' 라는 key의 값 반환
  print( record.$2 ); // key가 존재하지 않은  두번째 value

  // 4. JSON 형식
  dynamic json = { 'name' : 'Dash' , 'age' : 10 , 'color' : 'blue' };
  print( json );

}