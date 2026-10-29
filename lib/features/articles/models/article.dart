class Article {
  const Article({
    required this.id,
    required this.title,
    required this.authorName,
    required this.tags,
    this.coverImage,
    this.description = '',
  });

  final int id;
  final String title;
  final String authorName;
  final List<String> tags;
  final String? coverImage;
  final String description;

  factory Article.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final tagData = json['tag_list'] ?? json['tags'];

    // Fallback: gunakan cover_image atau social_image jika cover_image kosong
    final image = json['coverImage'] as String? ??
        json['cover_image'] as String? ??
        json['social_image'] as String?;

    // Parsing nama penulis
    String author = 'Penulis tidak diketahui';
    if (json['authorName'] != null) {
      author = json['authorName'].toString();
    } else if (user is Map && user['name'] != null) {
      author = user['name'].toString();
    }

    // Parsing daftar tag
    List<String> tagsList = const [];
    if (tagData is List) {
      tagsList = tagData.map((e) => e.toString()).toList();
    } else if (tagData is String && tagData.isNotEmpty) {
      tagsList = tagData.split(',').map((e) => e.trim()).toList();
    }

    return Article(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Tanpa judul',
      authorName: author,
      coverImage: image,
      tags: tagsList,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authorName': authorName,
      'tags': tags,
      'coverImage': coverImage,
      'description': description,
    };
  }
}