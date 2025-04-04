import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
