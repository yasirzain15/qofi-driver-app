class NameModel {
  String name;

  NameModel({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
