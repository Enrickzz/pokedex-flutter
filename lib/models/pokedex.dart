import 'dart:ui';

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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['results'] =
        results != null ? results.map((v) => v.toJson()).toList() : null;
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
  Sub_type? sub;

  Type({required this.slot, required this.sub});

  Type.fromJson(Map<String, dynamic> json) {
    slot = json['slot'].toString();
    if (json['type'] != null) {
      sub = Sub_type.fromJson(json['type']);
    }
  }
}

class Sub_type {
  String? name;
  String? url;
  Sub_type({required this.name, required this.url});

  Sub_type.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    url = json['url'].toString();
  }
}

Color pokemonColor(String? firstT) {
  switch (firstT) {
    case "grass":
      return Color.fromARGB(255, 63, 194, 85);
    case "fire":
      return Color.fromARGB(255, 228, 94, 41);
    case "water":
      return Color.fromARGB(255, 66, 132, 207);
    case "bug":
      return Color.fromARGB(255, 53, 88, 59);
    case "normal":
      return Color.fromARGB(255, 255, 255, 255);
    case "electric":
      return Color.fromARGB(255, 191, 218, 74);
    case "poison":
      return Color.fromARGB(255, 168, 63, 194);
    case "ground":
      return Color.fromARGB(255, 136, 100, 52);
    case "fairy":
      return Color.fromARGB(255, 208, 236, 142);
    case "fighting":
      return Color.fromARGB(255, 219, 151, 50);
    case "psychic":
      return Color.fromARGB(255, 196, 71, 144);
    case "ghost":
      return Color.fromARGB(255, 95, 110, 98);
    case "rock":
      return Color.fromARGB(255, 168, 170, 169);
    case "ice":
      return Color.fromARGB(255, 132, 225, 228);
    case "dragon":
      return Color.fromARGB(255, 235, 130, 44);
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
