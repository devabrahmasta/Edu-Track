import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/article_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onCategoryTapped(ArticleCategory category) {
    Navigator.of(context).pushNamed(
      AppRoutes.articles,
      arguments: category,
    );
  }

  void _searchDirectTopic(String topic) {
    if (topic.trim().isEmpty) return;
    final customCategory = ArticleCategory(
      name: 'Topik: "${topic.trim()}"',
      tag: topic.trim().toLowerCase().replaceAll(' ', ''),
      icon: Icons.search_rounded,
      description: 'Hasil pencarian materi untuk $topic',
      accentColor: AppColors.navy,
    );
    _onCategoryTapped(customCategory);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?.firstName ?? auth.user?.username ?? 'Pelajar';

    // Filter daftar kategori sesuai kata kunci pencarian
    final filteredCategories = ArticleCategory.defaults.where((cat) {
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) return true;
      return cat.name.toLowerCase().contains(query) ||
          cat.tag.toLowerCase().contains(query) ||
          cat.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Pengguna & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $userName 👋',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mau belajar apa hari ini?',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.muted,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.profile),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 1.5),
                        color: AppColors.surface,
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.greenSoft,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.green,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Notifikasi Sesi Offline (jika aktif)
              if (auth.user?.isOfflineSession == true) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.green.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          size: 18, color: AppColors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mode offline aktif (sesi akun demo)',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // 2. Kolom Pencarian (Search Bar sesuai ketentuan PNG)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  onSubmitted: _searchDirectTopic,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari topik belajar (contoh: flutter, python)...',
                    hintStyle: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.navy,
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                size: 18, color: AppColors.muted),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // 3. Banner Inspirasi Belajar (dengan Motif 3 Garis Warna dari PNG)
              if (_searchQuery.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Motif 3 garis warna dari PNG: Primary (Navy), Secondary (Green), Tertiary (Gold)
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 24,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Eksplorasi Materi Pilihan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 17,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Akses artikel, tips, dan panduan belajar pemrograman terkini langsung dari komunitas global.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 4. Opsi Pencarian Bebas ke API (muncul saat mengetik kata kunci)
              if (_searchQuery.trim().isNotEmpty) ...[
                InkWell(
                  onTap: () => _searchDirectTopic(_searchQuery),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.travel_explore_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Cari topik "$_searchQuery" di Dev.to API',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 5. Bagian Kategori Materi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kategori Materi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${filteredCategories.length} Topik',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Daftar Kategori yang Ramah Orang Awam
              if (filteredCategories.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: AppColors.muted,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kategori tidak ditemukan',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gunakan tombol biru di atas untuk mencari topik ini langsung ke server.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    return Card(
                      elevation: 0,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _onCategoryTapped(category),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              // Ikon Lingkaran Kategori (sesuai circle icons di PNG)
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: category.accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  category.icon,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Info Nama & Penjelasan Bahasa Awam
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      category.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: AppColors.muted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Panah Petunjuk Klik
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.muted,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),

      // 6. Floating Capsule Bottom Navigation Dock (Persis seperti di kanan bawah gambar PNG)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Home (Aktif dengan lingkaran Navy)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Tombol Cari (Fokus ke kolom pencarian di atas)
                    IconButton(
                      icon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.muted,
                      ),
                      tooltip: 'Cari Materi',
                      onPressed: () {
                        _searchFocusNode.requestFocus();
                      },
                    ),
                    const SizedBox(width: 8),

                    // Tombol Profil Pengguna
                    IconButton(
                      icon: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.muted,
                      ),
                      tooltip: 'Profil Saya',
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.profile);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}