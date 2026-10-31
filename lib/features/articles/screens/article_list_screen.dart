import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edu_track/core/app_colors.dart';
import 'package:edu_track/features/articles/models/article_category.dart';
import 'package:edu_track/features/articles/providers/article_provider.dart';
import 'package:edu_track/features/articles/widgets/article_card.dart';
import 'package:edu_track/features/articles/widgets/empty_view.dart';
import 'package:edu_track/features/articles/widgets/error_view.dart';
import 'package:edu_track/features/articles/widgets/loading_view.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({
    required this.category,
    super.key,
  });

  final ArticleCategory category;

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memuat data materi saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleProvider>().fetchArticles(widget.category.tag);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '#${widget.category.tag}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // FITUR 2: Kolom Pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {}); // Update tampilan tombol clear 'X'
                context.read<ArticleProvider>().search(query);
              },
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis, atau tag...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.muted,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.muted,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          context.read<ArticleProvider>().clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // FITUR 1 & 3: Loading, Error, Empty, dan Daftar Materi
          Expanded(
            child: Consumer<ArticleProvider>(
              builder: (context, provider, _) {
                // State 1: Memuat data (Loading)
                if (provider.isLoading) {
                  return const LoadingView(
                    message: 'Sedang mengambil materi dari Dev.to...',
                  );
                }

                // State 2: Terjadi galat jaringan/API (Error)
                if (provider.isError) {
                  return ErrorView(
                    message: provider.errorMessage ??
                        'Gagal memuat materi. Periksa koneksi internet Anda.',
                    onRetry: provider.retry,
                  );
                }

                // State 3a: Kategori memang belum ada data sama sekali dari API (Empty)
                if (provider.isEmpty) {
                  return EmptyView(
                    title: 'Belum Ada Materi',
                    message:
                        'Materi untuk kategori "${widget.category.name}" belum tersedia.',
                    icon: Icons.menu_book_outlined,
                  );
                }

                final articles = provider.articles;

                // State 3b: Tidak ada data yang cocok dengan kata kunci pencarian (Empty Search)
                if (articles.isEmpty) {
                  return EmptyView(
                    title: 'Materi Tidak Ditemukan',
                    message:
                        'Tidak ada materi yang sesuai dengan kata kunci "${provider.searchQuery}".',
                    icon: Icons.search_off_rounded,
                  );
                }

                // State 4: Sukses memuat daftar kartu materi (Daftar Materi)
                return RefreshIndicator(
                  color: AppColors.green,
                  onRefresh: () async {
                    await provider.fetchArticles(
                      widget.category.tag,
                      forceRefresh: true,
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () {
                          // Feedback saat kartu ditekan (siap disambungkan ke DetailScreen oleh Akyaz)
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membuka: ${article.title}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}