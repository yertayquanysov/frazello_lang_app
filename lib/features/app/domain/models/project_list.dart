class Language {
  Language({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static Language fromMap(Map data) {
    return Language(
      id: data["id"],
      name: data["name"],
    );
  }
}
