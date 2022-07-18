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
