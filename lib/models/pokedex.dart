class Pokemon {
  String? name;
  String? url;
  String img = "";
  String id = "";

  Pokemon({this.name, this.url, required this.img, required this.id});

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
// class ArrType {
//   List<Type> types = [];
// }

// class Type {
//   String slot = "";
//   Sub_type sub = Sub_type();

//   Type({required this.slot, required this.sub});

//   Type.fromJson(Map<String, dynamic> json) {
//     slot = json['slot'];
//     sub = json['type'];
//   }
// }

// class Sub_type {
//   String name = "";
//   String url = "";
//   Sub_type({required this.name, required this.url});
// }
