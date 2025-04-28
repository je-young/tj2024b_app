import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //이 위젯은 응용 프로그램의 루트입니다.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 이것은 응용 프로그램의 주제입니다.
        //
        // 이것을 시도하십시오 : "Flutter Run"으로 응용 프로그램을 실행해보십시오. 당신은 볼 것입니다
        // 응용 프로그램에는 자주색 도구 모음이 있습니다. 그런 다음 앱을 종료하지 않고
        // 아래 색상에서 SeedColor를 Colors.Green으로 변경해보십시오.
        // 그런 다음 "핫 리로드"를 호출하십시오 (변경 사항을 저장하거나 "핫을 누릅니다.
        // 플러터 지원 IDE의 Reload "버튼을 보거나 사용하는 경우"R "을 누릅니다.
        // 앱을 시작하려는 명령 줄).
        //
        // 카운터가 다시 0으로 재설정되지 않았 음을 알 수 있습니다. 응용 프로그램
        // 다시로드 중에 상태가 손실되지 않습니다. 상태를 재설정하려면 핫을 사용하십시오
        // 대신 다시 시작합니다.
        //
        // 이것은 값뿐만 아니라 코드에도 작동합니다. 대부분의 코드 변경은 다음과 같습니다.
        // 핫 리로드만으로 테스트했습니다.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  //이 위젯은 응용 프로그램의 홈페이지입니다. 그것은 진정한 의미입니다
  // 영향을 미치는 필드를 포함하는 상태 객체 (아래 정의)가 있습니다.
  // 어떻게 보이는지.

  //이 클래스는 상태의 구성입니다. 값을 보유합니다 (이것에서
  // 부모가 제공 한 제목 (이 경우 앱 위젯) 및
  // 상태의 빌드 방법에 사용됩니다. 위젯 서브 클래스의 필드는 다음과 같습니다
  // 항상 "최종"으로 표시되어 있습니다.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // SetState에 대한이 호출은 Flutter Framework에 무언가가
      //이 상태에서 변경되어 아래 빌드 방법을 다시 실행합니다.
      // 디스플레이가 업데이트 된 값을 반영 할 수 있도록합니다. 우리가 변경되면
      // _counter는 setState ()을 호출하지 않고 빌드 메소드가 아닙니다.
      // 다시 전화해서 아무 일도 일어나지 않을 것입니다.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    //이 메소드는 SetState가 호출 될 때마다 재실행됩니다 (예 : 완료)
    // 위의 _incrementCounter 메소드에 의해.
    //
    // 플러터 프레임 워크는 다시 시작하는 빌드 방법을 만들기 위해 최적화되었습니다.
    // 빠른, 오히려 업데이트가 필요한 모든 것을 재건 할 수 있도록
    // 위젯 인스턴스를 개별적으로 변경하는 것보다.
    return Scaffold(
      appBar: AppBar(
        // 이것을 시도하십시오 : 여기에서 색상을 특정 색상으로 변경해보십시오 (
        // colors.amber, 아마도?) 그리고 핫 재 장전을 트리거하여 AppBar를 볼 수 있습니다.
        // 다른 색상이 동일하게 유지되는 동안 색상 변경.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 여기에서 우리는 생성 된 myHomePage 객체에서 값을 가져옵니다.
        // app.build 메소드를 사용하여 AppBar 제목을 설정하는 데 사용합니다.
        title: Text(widget.title),
      ),
      body: Center(
        // 센터는 레이아웃 위젯입니다. 한 아이가 필요하고 위치합니다
        // 부모의 한가운데.
        child: Column(
          // 열은 또한 레이아웃 위젯입니다. 아이들의 목록을 취합니다
          // 수직으로 배열합니다. 기본적으로 크기 자체가 적합합니다
          // 어린이는 수평으로, 부모만큼 키가 큽니다.
          //
          // 칼럼에는 크기 자체의 크기를 제어하기위한 다양한 속성이 있습니다.
          // 자녀를 어떻게 배치하는지. 여기서 우리는 mainaxisalignment를 사용합니다
          // 어린이를 수직으로 중심으로; 여기의 주요 축은 수직입니다
          // 열이 수직이기 때문에 축 (교차 축은
          // 수평의).
          //
          // 이것을 시도하십시오 : "디버그 페인팅"을 호출하십시오 ( "토글 디버그 페인트"를 선택하십시오.
          // IDE에서 행동하거나 콘솔에서 "P"를 누르면
          // 각 위젯의 와이어 프레임.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //이 후행 쉼표는 빌드 방법을 위해 자동 형식화가 더 좋습니다.
    );
  }
}