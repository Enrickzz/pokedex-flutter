class Pokemon {
  String? name;
  String? url;
  String img = "";

  Pokemon({this.name, this.url, required this.img});

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
