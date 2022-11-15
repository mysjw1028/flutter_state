import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider -> 공급자
// Provider는 창고( repo )에 데이터를 공급. ( Provider가 repo를 들고있음 )
//final numProvider = Provider((_) => 2);
final numProvider = StateProvider((_) => 2);

void main() {
  runApp(
    // 위젯에서 프로바이더를 사용하고 읽기위해
    // 앱 전체적으로 "ProviderScope" 위젯을 감싸줘야 합니다.
    // 여기에 프로바이더의 상태가 저장됩니다.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: AComponent()),
          Expanded(child: BComponent()),
        ],
      ),
    );
  }
}

//소비자 : 소비자는 공급자 (Provider)에게 데이터를 요청한다. 공급자는 창고에서 데이터를 껀꺼내서 돌려준다.
class AComponent extends ConsumerWidget {
  const AComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //소비를 한번만 할때 read를 사용
    //watch(리스너 -> 지켜만봄/ while해서 확인해서)는 numProvider의 값이 변경될 때 마다 rebuild됨
    //값을 읽고 지지고 쓸려고 -> 로그찍는게 아님
    //안바뀌는데 watch를 쓰면 낭비
    //Provider에 보통 세션을 사용함 -> 어디에서든 땡겨쓰면됨

    //int num = ref.read(numProvider); //한번밖에 사용안됨
    int num = ref.watch(numProvider); //한번밖에 사용안됨

    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          Text("ACompoent"),
          Expanded(
            child: Align(
              child: Text(
                "$num",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 서플라이어 공급자
class BComponent extends ConsumerWidget {
  const BComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          Text("BCompoent"),
          Expanded(
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  final result = ref.read(numProvider.notifier);
                  result.state += 5;
                },
                child: Text(
                  "숫자증가",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
