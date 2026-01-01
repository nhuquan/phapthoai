class Audio {
  final String title;
  final String url;

  Audio({required this.title, required this.url});

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}

class Collection {
  final String title;
  final List<Audio> audios;

  Collection({required this.title, required this.audios});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      title: json['collection'] as String,
      audios: (json['audios'] as List)
          .map((e) => Audio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
