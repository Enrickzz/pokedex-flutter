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
Root? holder;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
    http
        .get(Uri.parse("https://pokeapi.co/api/v2/pokemon/?limit=905"))
        .then((json) {
      holder = Root.fromJson(jsonDecode(json.body));
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
        } else {
          getPokemons(offsetTracker + 20).then((value) {
            offsetTracker = offsetTracker + 20;
            setState(() {});
          });
        }
      }
    });
    getPokemons(offsetTracker).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Pokédex", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
              child: Center(
                child: TextField(
                  onChanged: (query) async {
                    pokemons.clear();
                    if (query != "") {
                      for (var i = 0; i < holder!.results.length; i++) {
                        if (holder!.results[i].name
                            .toString()
                            .startsWith(query.toString(), 0)) {
                          Pokemon thisPokemon = holder!.results[i];
                          String apiID =
                              thisPokemon.url.toString().split("/")[6];
                          thisPokemon.id = apiID; //for onClick queries
                          thisPokemon.img =
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$apiID.png";
                          http
                              .get(Uri.parse(
                                  "https://pokeapi.co/api/v2/pokemon/$apiID"))
                              .then((value) {
                            thisPokemon.pokemonType =
                                ArrType.fromJson(jsonDecode(value.body));
                            pokemons.add(thisPokemon);
                            setState(() {});
                          });
                        }
                      }
                    } else {
                      offsetTracker = 0;
                      pokemons.clear();
                      getPokemons(offsetTracker).then((value) {
                        setState(() {});
                      });
                    }
                  },
                  showCursor: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
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
                // ignore: unnecessary_null_comparison
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
                                padding: const EdgeInsets.fromLTRB(20, 1, 1, 1),
                                child: nullCheck(pokemons[index]
                                    .pokemonType
                                    ?.types[0]
                                    .sub!
                                    .name
                                    .toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 1, 1, 1),
                                child: Visibility(
                                  visible: bool2ndType,
                                  child: Center(
                                    child: nullCheck(string2ndType),
                                  ),
                                ),
                              ),
                            ]),
                            Container(
                              width: 80,
                              height: 100,
                              alignment: Alignment.centerRight,
                              child: Image.network(
                                pokemons[index].img, // this image doesn't exist
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.amber,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Whoops!',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  );
                                },
                              ),
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
          ),
        ));
  }
}

Future<List<Pokemon>> getPokemons(int offset) async {
  List<Pokemon> fullList = [];
  Root test = Root(results: fullList);
  await http
      .get(Uri.parse(
          'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=$offset'))
      .then((value) async {
    if (offset == 0) {
      pokemons.clear();
    }
    test = Root.fromJson(jsonDecode(value.body));
    for (var i = 0; i < test.results.length; i++) {
      int query = i + offset + 1;
      if (query > 905) {
        break;
      }
      pokemons.add(test.results[i]);
      pokemons[i + offset].id = query.toString(); //for onClick queries
      pokemons[i + offset].img =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$query.png";
      await http
          .get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$query"))
          .then((value) {
        pokemons[i + offset].pokemonType =
            ArrType.fromJson(jsonDecode(value.body));
      });
    }
  });
  return test.results;
}
