// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/detailed_view.dart';
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
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int offsetTracker = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  initState() {
    getPokemons(offsetTracker).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                //Data clean up/ null checking operations
                String first = pokemons[index].name.toString();
                String name = first[0].toUpperCase() + first.substring(1);
                bool bool2ndType = true;
                String? string2ndType;
                String? firstT = pokemons[index]
                        .pokemonType
                        ?.types
                        .first
                        .sub!
                        .name
                        .toString(),
                    lastT = pokemons[index]
                        .pokemonType
                        ?.types
                        .last
                        .sub!
                        .name
                        .toString();
                if (lastT != firstT) {
                  string2ndType = pokemons[index]
                      .pokemonType!
                      .types[1]
                      .sub!
                      .name
                      .toString();
                }
                Color boxColor = pokemonColor(firstT);
                return Center(
                  child: GestureDetector(
                    child: Container(
                      width: 165,
                      height: 165,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: boxColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(children: [
                        const SizedBox(height: 8),
                        Text(
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.left,
                            "$name\n"),
                        Row(
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 1, 1, 1),
                                child: nullCheck(pokemons[index]
                                    .pokemonType
                                    ?.types[0]
                                    .sub!
                                    .name
                                    .toString()),
                              ),
                              const SizedBox(height: 3),
                              Visibility(
                                  visible: bool2ndType,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(40, 1, 1, 1),
                                    child: nullCheck(string2ndType),
                                  ))
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
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PokemonDetailed(
                                  thisPokemon: pokemons[index])));
                    },
                  ),
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

Color pokemonColor(String? firstT) {
  switch (firstT) {
    case "grass":
      return const Color.fromARGB(255, 63, 194, 85);
    case "fire":
      return const Color.fromARGB(255, 228, 94, 41);
    case "water":
      return const Color.fromARGB(255, 66, 132, 207);
    case "bug":
      return const Color.fromARGB(255, 53, 88, 59);
    case "normal":
      return const Color.fromARGB(255, 255, 255, 255);
    case "electric":
      return const Color.fromARGB(255, 191, 218, 74);
    case "poison":
      return const Color.fromARGB(255, 168, 63, 194);
    case "ground":
      return const Color.fromARGB(255, 136, 100, 52);
    case "fairy":
      return const Color.fromARGB(255, 208, 236, 142);
    case "fighting":
      return const Color.fromARGB(255, 219, 151, 50);
    case "psychic":
      return const Color.fromARGB(255, 196, 71, 144);
    case "ghost":
      return const Color.fromARGB(255, 95, 110, 98);
    case "rock":
      return const Color.fromARGB(255, 168, 170, 169);
    case "ice":
      return const Color.fromARGB(255, 132, 225, 228);
    case "dragon":
      return const Color.fromARGB(255, 235, 130, 44);
    default:
      return Colors.white;
  }
}

Future<List<Pokemon>> getPokemons(int offset) async {
  List<Pokemon> fullList = [];
  Root test = Root(results: fullList);
  await http
      .get(Uri.parse(
          'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=$offset'))
      .then((value) async {
    test = Root.fromJson(jsonDecode(value.body));
    for (var i = 0; i < test.results.length; i++) {
      int query = i + offset + 1;
      pokemons.add(test.results[i]);
      pokemons[i + offset].id = query.toString(); //for onClick queries
      pokemons[i + offset].img =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$query.png";
      http
          .get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$query"))
          .then((value) {
        pokemons[i + offset].pokemonType =
            ArrType.fromJson(jsonDecode(value.body));
      });
    }
  });
  return test.results;
}

Widget nullCheck(String? text) {
  if (text == null) {
    return const Text("");
  } else {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}
