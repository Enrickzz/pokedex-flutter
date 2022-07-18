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
  int offsetTracker = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    getPokemons(offsetTracker).then((value) {
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
        body: NotificationListener(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  childAspectRatio: 1,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                String first = pokemons[index].name.toString();
                String name = first[0].toUpperCase() + first.substring(1);
                return Center(
                  child: GestureDetector(
                      child: Container(
                    width: 165,
                    height: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(children: [
                      SizedBox(height: 8),
                      Text(
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          name + "\n"),
                      Row(
                        children: [
                          Column(children: [
                            Container(
                              width: 70,
                              // ignore: prefer_const_constructors
                              child: Text(
                                "category",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              width: 70,
                              // ignore: prefer_const_constructors
                              child: Text(
                                "category2",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]),
                          Container(
                            width: 95,
                            height: 100,
                            alignment: Alignment.centerRight,
                            child: Image.network(pokemons[index].img),
                          )
                        ],
                      ),
                    ]),
                  )),
                );
              },
            ),
            onNotification: (end) {
              if (end is ScrollEndNotification) {
                getPokemons(offsetTracker + 20).then((value) {
                  offsetTracker = offsetTracker + 20;
                  setState(() {});
                });
              }
              return true;
            }));
  }
}

Future<List<Pokemon>> getPokemons(int offset) async {
  List<Pokemon> fullList = [];
  Root test = new Root(results: fullList);
  final response = await http
      .get(Uri.parse(
          'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=$offset'))
      .then((value) async {
    // print(value.body);
    test = Root.fromJson(jsonDecode(value.body));
    for (var i = 0; i < test.results.length; i++) {
      int query = i + offset + 1;
      pokemons.add(test.results[i]);
      pokemons[i + offset].id = query.toString(); //for onClick queries
      pokemons[i + offset].img =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$query.png";
    }
  });
  return test.results;
}
