import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class ArticleService {
  Future<List<Article>> fetchArticles(String tag) async {
    final uri = Uri.https(
      'dev.to',
      '/api/articles',
      {'tag': tag, 'per_page': '20'},
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 12),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat materi (HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Format daftar materi tidak sesuai.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Data materi tidak sesuai.');
      }

      return Article.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }
}