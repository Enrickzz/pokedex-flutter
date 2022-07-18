import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/pokedex.dart';

void main() {
  runApp(const MyApp());
}

List<Pokemon> pokemons = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  initState() {
    getPokemons().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1),
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
                child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 27, 29, 27), spreadRadius: 3),
                ],
              ),
              child: Column(children: [
                Text(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                    pokemons[index].name.toString() + "\n"),
                Container(
                  width: 150,
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: Image.network(pokemons[index].img),
                )
              ]),
            )),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getPokemons();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<List<Pokemon>> getPokemons() async {
  List<Pokemon> fullList = [];
  Root test = new Root(results: fullList);
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'))
      .then((value) async {
    print(value.body);
    test = Root.fromJson(jsonDecode(value.body));
    pokemons = test.results;

    for (var i = 0; i < pokemons.length; i++) {
      int a = i + 1;
      pokemons[i].img =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$a.png";
    }

    // print("ASD = >" + test.results.length.toString());
  });
  return test.results;
}
