import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      routes: {
        "/": (c) => const MyIndexWidget(),
        "/book": (c) => const MyBookWidget(),
        "/clink": (c) => const MyClinkWidget(),
        "/login": (c) => const MyLoginWidget(),
        "/home": (c) => const MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}

class MyIndexWidget extends StatelessWidget {
  const MyIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Index Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/book"),
              child: const Text("MyBookWidget Nav"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/clink"),
              child: const Text("ClinkDemo Nav"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/login"),
              child: const Text("LoginDemo Nav"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBookWidget extends StatefulWidget {
  const MyBookWidget({super.key});

  @override
  State<MyBookWidget> createState() => _MyBookWidgetState();
}

class _MyBookWidgetState extends State<MyBookWidget> {
  int len = Random().nextInt(16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: len > 5
          ? PageView.builder(
              controller: PageController()..addListener(() {}),
              onPageChanged: (value) {
                if (value + 1 == len) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("this end")),
                  );
                }
              },
              scrollDirection: Axis.vertical,
              itemCount: len,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        'https://picsum.photos/200/300?random=${index + 1}',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.grey,
                        child: Text(
                          '${index + 1}/$len',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(child: Text("no find data")),
    );
  }
}

class MyLoginWidget extends StatefulWidget {
  const MyLoginWidget({super.key});

  @override
  State<MyLoginWidget> createState() => _MyLoginWidgetState();
}

class _MyLoginWidgetState extends State<MyLoginWidget> {
  final _ctr = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: TextField(
            controller: _ctr,
            decoration: const InputDecoration(hintText: "input you username"),
          ),
        ),
        ElevatedButton(
          onPressed: () => {
            Navigator.of(context).popAndPushNamed(
              "/home",
              arguments: {"userName": _ctr.text},
            )
          },
          child: const Text("Login In"),
        ),
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ??
            {"userName": ""};
    final userName = args["userName"];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('hello $userName'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popAndPushNamed("/login"),
              child: const Text("Login Out"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClinkWidget extends StatelessWidget {
  const MyClinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ClinkDemo")),
      body: Center(
          child: Column(
        children: List<Widget>.generate(
          4,
          (index) => OptionListItem(
            action: String.fromCharCode(index + 65),
            content: 'Spend no more than ${index + 3}0 dollars',
          ),
        ),
      )),
    );
  }
}

class OptionListItem extends StatefulWidget {
  final String action;
  final String content;

  const OptionListItem(
      {super.key, required this.action, required this.content});

  @override
  State<OptionListItem> createState() => _OptionListItemState();
}

class _OptionListItemState extends State<OptionListItem> {
  bool _tap = false;
  bool _longPress = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InkWell(
        onTap: () {
          if (!_longPress) {
            _tap = !_tap;
            setState(() {});
          }
        },
        onLongPress: () {
          if (!_tap) {
            _longPress = !_longPress;
            setState(() {});
          }
        },
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tap ? Colors.blue[100] : Colors.transparent,
                borderRadius: BorderRadius.circular(1000),
                border: Border.all(
                  width: 1,
                  color: _tap
                      ? Colors.blue[200]!
                      : _longPress
                          ? Colors.grey
                          : Colors.black,
                ),
              ),
              child: Text(
                widget.action,
                style: TextStyle(
                  color: _tap
                      ? Colors.blue
                      : _longPress
                          ? Colors.grey
                          : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.content,
                style: TextStyle(
                  color: _longPress ? Colors.grey : Colors.black,
                  decoration: _longPress
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawerWidget extends StatefulWidget {
  const MyDrawerWidget({super.key});

  @override
  State<MyDrawerWidget> createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DrawerDemo")),
      body: Stack(
        children: [ListView(), ListView()],
      ),
    );
  }
}
