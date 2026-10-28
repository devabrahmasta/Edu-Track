import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/routes.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: FilledButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
            child: const Text('Kembali ke halaman masuk'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.greenSoft,
            backgroundImage: user.image.isEmpty
                ? null
                : NetworkImage(user.image),
            child: user.image.isEmpty
                ? const Icon(Icons.person, color: AppColors.green, size: 42)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (user.isOfflineSession) ...[
            const SizedBox(height: 20),
            const _OfflineSessionBanner(),
          ],
          const SizedBox(height: 28),
          Card(
            color: AppColors.surface,
            child: ListTile(
              leading: const Icon(
                Icons.alternate_email,
                color: AppColors.green,
              ),
              title: const Text('Username'),
              subtitle: Text(user.username),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.surface,
            child: ListTile(
              leading: const Icon(
                Icons.bookmark_border,
                color: AppColors.green,
              ),
              title: const Text('Bookmark tersimpan'),
              trailing: Text(
                '${context.watch<AuthProvider>().bookmarkCount}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineSessionBanner extends StatelessWidget {
  const _OfflineSessionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Sesi demo offline aktif. Gunakan hanya untuk pengujian.',
        style: TextStyle(color: AppColors.green),
      ),
    );
  }
}
