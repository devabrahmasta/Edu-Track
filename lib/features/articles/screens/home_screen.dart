import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/routes.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTrack'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${auth.user?.firstName ?? auth.user?.username ?? 'Pelajar'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sesi belajar kamu siap dilanjutkan.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (auth.user?.isOfflineSession == true) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kamu masuk menggunakan sesi demo offline.',
                  style: TextStyle(color: AppColors.green),
                ),
              ),
            ],
            const Spacer(),
            const Text(
              'Beranda materi akan tersedia setelah fitur kategori dan artikel '
              'terintegrasi.',
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
