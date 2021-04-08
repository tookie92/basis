class Person {
  String? id;
  String? name;

  Person(this.name);

  Person.fromMap(Map<String, dynamic> map, String id)
      : id = id,
        name = map['name'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'name': this.name};
    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
