import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/all.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class CounterModel extends StateNotifier<int> {
  CounterModel() : super(5);

  int get computedState => state + 1;

  void increment() => state--;
}

final counterProvider = StateNotifierProvider((ref) {
  return CounterModel();
});

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage();

  @override
  Widget build(context, watch) {
    // `watch(counterProvider)` will listen to chagnes in the CounterModel if we update `state + 1` into `state + 2` hot reload will actually works
    final count = watch(counterProvider);

    // `this time we listen to `state` so it wil trigger re render everytime we hit '+' button
    final countState = watch(counterProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text('MobX Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' ${count.computedState} jYou have pushed the button this many times:',
            ),
            // Wrapping in the Observer will automatically re-render on changes to counter.value
            Observer(
              builder: (_) => Text(
                '${countState}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read(counterProvider).increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
