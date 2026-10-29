import 'package:flutter/foundation.dart';
import 'package:edu_track/features/articles/models/article.dart';
import 'package:edu_track/features/articles/services/article_service.dart';

enum ArticleState { initial, loading, loaded, empty, error }

class ArticleProvider extends ChangeNotifier {
  ArticleProvider({ArticleService? articleService})
      : _articleService = articleService ?? ArticleService();

  final ArticleService _articleService;

  ArticleState _state = ArticleState.initial;
  List<Article> _allArticles = [];
  String _searchQuery = '';
  String? _errorMessage;
  String? _currentTag;

  ArticleState get state => _state;
  bool get isLoading => _state == ArticleState.loading;
  bool get isError => _state == ArticleState.error;
  bool get isEmpty => _state == ArticleState.empty;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Mengembalikan list materi yang terfilter otomatis berdasarkan kata kunci pencarian
  List<Article> get articles {
    if (_searchQuery.trim().isEmpty) {
      return _allArticles;
    }

    final query = _searchQuery.toLowerCase().trim();
    return _allArticles.where((article) {
      final matchTitle = article.title.toLowerCase().contains(query);
      final matchAuthor = article.authorName.toLowerCase().contains(query);
      final matchTag = article.tags.any(
        (tag) => tag.toLowerCase().contains(query),
      );
      return matchTitle || matchAuthor || matchTag;
    }).toList();
  }

  // Mengambil daftar materi dari Dev.to API
  Future<void> fetchArticles(String tag, {bool forceRefresh = false}) async {
    _currentTag = tag;
    _searchQuery = '';
    _state = ArticleState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _articleService.fetchArticles(tag);
      _allArticles = results;

      if (_allArticles.isEmpty) {
        _state = ArticleState.empty;
      } else {
        _state = ArticleState.loaded;
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      _state = ArticleState.error;
    } finally {
      notifyListeners();
    }
  }

  // Filter pencarian
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Hapus pencarian
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Coba lagi saat error
  void retry() {
    if (_currentTag != null) {
      fetchArticles(_currentTag!, forceRefresh: true);
    }
  }
}