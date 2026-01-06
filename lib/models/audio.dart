class Audio {
  final String title;
  final String url;
  final String? date;

  Audio({required this.title, required this.url, this.date});

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      title: json['title'] as String,
      url: json['url'] as String,
      date: json['date'] as String?,
    );
  }
}

class Collection {
  final String title;
  final List<Audio> audios;
  final bool isFavorite;

  Collection({
    required this.title,
    required this.audios,
    this.isFavorite = false,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      title: json['collection'] as String,
      audios:
          (json['audios'] as List)
              .map((e) => Audio.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Collection copyWith({
    String? title,
    List<Audio>? audios,
    bool? isFavorite,
  }) {
    return Collection(
      title: title ?? this.title,
      audios: audios ?? this.audios,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
