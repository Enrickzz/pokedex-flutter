import 'package:flutter/material.dart';

class Pokemon {
  String? name;
  String? url;
  String img = "";
  String id = "";
  ArrType? pokemonType;

  Pokemon(
      {this.name,
      this.url,
      required this.img,
      required this.id,
      this.pokemonType});

  Pokemon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Root {
  List<Pokemon> results = [];

  Root({required this.results});

  Root.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Pokemon>[];
      json['results'].forEach((v) {
        results.add(Pokemon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

/* TO TEST = TYPE PARSE */
class ArrType {
  List<Type> types = [];

  ArrType.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      types = <Type>[];
      json['types'].forEach((v) {
        types.add(Type.fromJson(v));
      });
    }
  }
}

class Type {
  String slot = "";
  SubType? sub;

  Type({required this.slot, required this.sub});

  Type.fromJson(Map<String, dynamic> json) {
    slot = json['slot'].toString();
    if (json['type'] != null) {
      sub = SubType.fromJson(json['type']);
    }
  }
}

class SubType {
  String? name;
  String? url;
  SubType({required this.name, required this.url});

  SubType.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    url = json['url'].toString();
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
