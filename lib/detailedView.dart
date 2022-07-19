// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'models/pokedex.dart';

class PokemonDetailed extends StatefulWidget {
  const PokemonDetailed({super.key, required this.thisPokemon});

  final Pokemon thisPokemon;

  @override
  State<PokemonDetailed> createState() => _PokemonDetailed();
}

class _PokemonDetailed extends State<PokemonDetailed> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String first = widget.thisPokemon.name.toString();
    String name = first[0].toUpperCase() + first.substring(1);
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 200,
            width: 200,
            child: Column(children: [
              Container(
                width: 150,
                height: 150,
                child: Image.network(
                  widget.thisPokemon.img,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(name.toString()))
            ]),
          ),
        ),
        const Center(child: Text(""))
      ],
    ));
  }
}
